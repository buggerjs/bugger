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
uv_async_t child_signal_;
uv_mutex_t message_mutex_;
uv_thread_t thread_;

Environment* parent_env_;
Environment* child_env_;

std::deque<Utf8String*> messages_;

Nan::Persistent<v8::Object> api_;


Environment* GetCurrentEnvironment(v8::Local<v8::Context> context) {
  return static_cast<Environment*>(
      context->GetAlignedPointerFromEmbedderData(v8::internal::Internals::kContextEmbedderDataIndex));
}

void EnqueueMessage(Utf8String* message) {
    printf("EnqueueMessage\n");
    uv_mutex_lock(&message_mutex_);
    messages_.push_back(message);
    uv_mutex_unlock(&message_mutex_);
    // After enqueing the message, wake up child thread.
    uv_async_send(&child_signal_);
}

void MessageHandler(const Debug::Message& message) {
    printf("MessageHandler\n");
    HandleScope scope;
    Local<String> json = message.GetJSON();
    Utf8String* utf8 = new Utf8String(json);

    EnqueueMessage(utf8);
}

void InitAdaptor(Isolate* isolate, Local<v8::Context> context) {
    HandleScope scope;
    printf("InitAdaptor\n");

    v8::Local<v8::FunctionTemplate> tpl = Nan::New<v8::FunctionTemplate>();
    tpl->SetClassName(Nan::New("EmbeddedAgents").ToLocalChecked());
    tpl->InstanceTemplate()->SetInternalFieldCount(1);

    Local<v8::Object> api = tpl->GetFunction()->NewInstance();
    api_.Reset(api);

    Local<v8::Object> global = context->Global();
    Nan::Set(global, Nan::New<String>("embeddedAgents").ToLocalChecked(), api);
}

void WorkerRun() {
    // TODO: Derive this from an argument instead of depending
    // on the current working directory.
    static const char* argv[] = { "node", "_index.js" };
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
        printf("Run _index.js\n");
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
    printf("Thread callback\n");
    WorkerRun();
}

void ChildSignalCb(uv_async_t* signal) {
    HandleScope scope;

    printf("Child signal received\n");
    uv_mutex_lock(&message_mutex_);
    while (messages_.size() > 0) {
        Utf8String* message = messages_.front();
        printf("Use message!\n");
        Local<v8::Value> json[] = { New<String>(**message).ToLocalChecked() };
        Local<v8::Object> api = New(api_);
        Nan::MakeCallback(api, "onMessage", 1, json);
        delete message;
        messages_.pop_front();
    }
    uv_mutex_unlock(&message_mutex_);
}

bool InitAgentThread() {
    printf("Start a new thread!\n");
    int err;

    err = uv_loop_init(&child_loop_);
    if (err != 0) {
        goto loop_init_failed;
    }

    // Interruption signal handler
    err = uv_async_init(&child_loop_, &child_signal_, ChildSignalCb);
    if (err != 0) {
        goto async_init_failed;
    }
    uv_unref(reinterpret_cast<uv_handle_t*>(&child_signal_));

    err = uv_thread_create(&thread_,
                           reinterpret_cast<uv_thread_cb>(ThreadCb),
                           nullptr);
    if (err != 0) {
        goto thread_create_failed;
    }

    Debug::SetMessageHandler(MessageHandler);

    return true;

thread_create_failed:
    uv_close(reinterpret_cast<uv_handle_t*>(&child_signal_), nullptr);

async_init_failed:
    uv_loop_close(&child_loop_);

loop_init_failed:
    return false;
}

NAN_METHOD(Start) {
    uv_mutex_init(&message_mutex_);

    parent_env_ = GetCurrentEnvironment(Nan::GetCurrentContext());
    info.GetReturnValue().Set(InitAgentThread());
}

NAN_METHOD(SendCommand) {
    String::Value v(info[0]);
    Debug::SendCommand(Isolate::GetCurrent(), *v, v.length());
    // TODO: process debug commands
    Debug::ProcessDebugMessages();
}

NAN_MODULE_INIT(InitAll) {
    Set(target, New<String>("sendCommand").ToLocalChecked(),
        GetFunction(New<FunctionTemplate>(SendCommand)).ToLocalChecked());
    
    Set(target, New<String>("start").ToLocalChecked(),
        GetFunction(New<FunctionTemplate>(Start)).ToLocalChecked());
}

NODE_MODULE(AgentDebug, InitAll)
