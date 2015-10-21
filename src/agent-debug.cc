#include <nan.h>
#include <v8-debug.h>
#include <deque>

using v8::String;
using v8::FunctionTemplate;
using v8::Isolate;
using v8::Debug;
using v8::Local;
using v8::Context;

using Nan::GetFunction;
using Nan::New;
using Nan::Set;
using Nan::HandleScope;
using Nan::Utf8String;

using node::Environment;

uv_loop_t child_loop_;
uv_thread_t thread_;
uv_sem_t start_sem_;

Isolate* parent_isolate_;
Environment* parent_env_;
Environment* child_env_;

Nan::Persistent<v8::Object> api_;

template<class ChannelClass>
class MessageChannel {
public:
    MessageChannel() {
        uv_mutex_init(&mutex);
    }

    void EnqueueMessage(Utf8String* message) {
        uv_mutex_lock(&mutex);
        messages.push_back(message);
        uv_mutex_unlock(&mutex);

        uv_async_send(&message_signal);
    }

protected:
    static void ProcessMessagesCb(uv_async_t* sig) {
        HandleScope scope;
        ChannelClass* channel = reinterpret_cast<ChannelClass*>(sig);

        uv_mutex_lock(&channel->mutex);
        while (channel->messages.size() > 0) {
            Utf8String* message = channel->messages.front();
            channel->ProcessMessage(message);
            delete message;
            channel->messages.pop_front();
        }
        uv_mutex_unlock(&channel->mutex);
    }

    void InitSignal(uv_loop_t* loop) {
        uv_async_init(loop, &message_signal, ProcessMessagesCb);
        uv_unref(reinterpret_cast<uv_handle_t*>(&message_signal));
    }

    void ProcessMessage(Utf8String* message);

private:
    uv_async_t message_signal; // Important this is first
    uv_mutex_t mutex;
    std::deque<Utf8String*> messages;
};

class TargetMethodMessageChannel : public MessageChannel<TargetMethodMessageChannel> {
public:
    void Init(uv_loop_t* loop, Local<v8::Object> target, const char* method) {
        HandleScope scope;
        this->InitSignal(loop);

        this->target.Reset(target);
        this->method = method;
    }

protected:
    friend class MessageChannel;

    void ProcessMessage(Utf8String* message) {
        Local<v8::Value> json[] = { New<String>(**message).ToLocalChecked() };
        Local<v8::Object> obj = New(target);
        Nan::MakeCallback(obj, method.c_str(), 1, json);
    }

private:
    std::string method;
    Nan::Persistent<v8::Object> target;
};

class DebugCallMessageChannel : public MessageChannel<DebugCallMessageChannel> {
public:
    void Init(uv_loop_t* loop,
              Local<v8::Function> func) {
        HandleScope scope;
        this->InitSignal(loop);

        this->func.Reset(func);
    }

protected:
    friend class MessageChannel;

    void ProcessMessage(Utf8String* message) {
        printf("Creating scope\n");
        HandleScope scope;
        printf("ProcessMessage via Debug::Call\n");
        Local<v8::Function> fun = New(func);
        Local<v8::Value> data = New<String>(**message).ToLocalChecked();
        printf("Making Debug::Call\n");
        Local<v8::Value> result = Debug::Call(fun, data);
        printf("Made Debug::Call\nstr:%d\n", result->IsString());
    }

private:
    Nan::Persistent<v8::Function> func;
};

TargetMethodMessageChannel from_parent_;
DebugCallMessageChannel to_parent_;

Environment* GetCurrentEnvironment(v8::Local<v8::Context> context) {
  return static_cast<Environment*>(
      context->GetAlignedPointerFromEmbedderData(v8::internal::Internals::kContextEmbedderDataIndex));
}

void MessageHandler(const Debug::Message& message) {
    HandleScope scope;
    Local<String> json = message.GetJSON();
    Utf8String* utf8 = new Utf8String(json);

    printf("Send message to child thread\n");
    from_parent_.EnqueueMessage(utf8);
}

NAN_METHOD(NotifyReady) {
    // Notify other thread that we are ready to process events
    uv_sem_post(&start_sem_);
}

NAN_METHOD(SendMessageToParent) {
    printf("Send message to target thread\n");
    // Utf8String* utf8 = new Utf8String(info[0]);
    // to_parent_.EnqueueMessage(utf8);
    String::Value v(info[0]);
    v8::Debug::SendCommand(parent_isolate_, *v, v.length());
}

void InitAdaptor(Isolate* isolate, Local<v8::Context> context) {
    HandleScope scope;

    v8::Local<v8::FunctionTemplate> tpl = Nan::New<v8::FunctionTemplate>();
    tpl->SetClassName(Nan::New("EmbeddedAgents").ToLocalChecked());
    tpl->InstanceTemplate()->SetInternalFieldCount(1);

    Nan::SetPrototypeMethod(tpl, "notifyReady", NotifyReady);
    Nan::SetPrototypeMethod(tpl, "sendMessage", SendMessageToParent);

    Local<v8::Object> api = tpl->GetFunction()->NewInstance();
    api_.Reset(api);

    // Create debug event channel
    from_parent_.Init(&child_loop_, api, "onMessage");

    Local<v8::Object> global = context->Global();
    Nan::Set(global, Nan::New<String>("embeddedAgents").ToLocalChecked(), api);
}

void WorkerRun() {
    // TODO: Derive this from an argument instead of depending
    // on the current working directory.
    static const char* argv[] = { "node", "lib/io-thread/index.js" };
    Isolate* isolate = Isolate::New();
    {
        v8::Locker locker(isolate);
        Isolate::Scope isolate_scope(isolate);

        v8::HandleScope handle_scope(isolate);
        Local<Context> context = Context::New(isolate);

        Context::Scope context_scope(context);
        Environment* env = node::CreateEnvironment(
            isolate,
            &child_loop_,
            context,
            2, // ARRAY_SIZE(argv),
            argv,
            2, // ARRAY_SIZE(argv),
            argv);

        child_env_ = env;
        
        // Expose API
        InitAdaptor(isolate, context);
        LoadEnvironment(env);

        // CHECK_EQ(&child_loop_, env->event_loop());
        uv_run(&child_loop_, UV_RUN_DEFAULT);

        // Clean-up peristent
        api_.Reset();

        // This is unfortunately not exposed in node.h:
        // env->CleanupHandles();
        // env->Dispose();

        env = nullptr;
    }
    isolate->Dispose();
}

void ThreadCb(void* arg) {
    WorkerRun();
}

void ParentSignalCb(uv_async_t* signal) {
    HandleScope scope;
}

bool InitAgentThread(Local<v8::Function> cb) {
    HandleScope scope;

    int err;

    err = uv_loop_init(&child_loop_);
    if (err != 0) {
        goto loop_init_failed;
    }

    to_parent_.Init(&child_loop_, cb);

    err = uv_thread_create(&thread_,
                           reinterpret_cast<uv_thread_cb>(ThreadCb),
                           nullptr);
    if (err != 0) {
        goto thread_create_failed;
    }

    uv_sem_wait(&start_sem_);

    Debug::SetMessageHandler(MessageHandler);

    return true;

thread_create_failed:
    uv_loop_close(&child_loop_);

loop_init_failed:
    return false;
}

NAN_METHOD(Start) {
    uv_sem_init(&start_sem_, 0);

    parent_isolate_ = Isolate::GetCurrent();
    parent_env_ = GetCurrentEnvironment(Nan::GetCurrentContext());
    info.GetReturnValue().Set(InitAgentThread(info[0].As<v8::Function>()));
}

NAN_METHOD(SendCommand) {
    String::Value v(info[0]);
    Debug::SendCommand(Isolate::GetCurrent(), *v, v.length());
    Debug::ProcessDebugMessages();
}

NAN_MODULE_INIT(InitAll) {
    Set(target, New<String>("sendCommand").ToLocalChecked(),
        GetFunction(New<FunctionTemplate>(SendCommand)).ToLocalChecked());
    
    Set(target, New<String>("start").ToLocalChecked(),
        GetFunction(New<FunctionTemplate>(Start)).ToLocalChecked());
}

NODE_MODULE(AgentDebug, InitAll)
