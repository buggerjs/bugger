#include <nan.h>
#include <v8-debug.h>

#include "../deps/fuq/fuq.h"

using namespace Nan;

class ArrayBufferAllocator : public v8::ArrayBuffer::Allocator {
 public:
  virtual void* Allocate(size_t length) {
    void* data = AllocateUninitialized(length);
    return data == NULL ? data : memset(data, 0, length);
  }
  virtual void* AllocateUninitialized(size_t length) { return malloc(length); }
  virtual void Free(void* data, size_t) { free(data); }
};

class ChildThread;

class ThreadProxy : public Nan::ObjectWrap {
public:
  static NAN_MODULE_INIT(Init);

private:
  ThreadProxy(const char* filename,
              const v8::Local<v8::Function> &handle_message);
  ~ThreadProxy();

  static NAN_METHOD(NewInstance);
  static NAN_METHOD(Poll);

  static void ThreadCb(void *arg) {
    static_cast<ThreadProxy*>(arg)->ChildMain();
  }
  void ChildMain();

  std::string filename_;
  Callback handle_message_from_child_;

  ChildThread *child_api_;

  uv_thread_t child_;
  uv_sem_t child_ready_sem_;
  uv_loop_t child_loop_;

  node::Environment *child_env_;
};

class ChildThread : public ObjectWrap {
public:
  ChildThread(ThreadProxy *thread) : thread_(thread) {
  }

  void InjectIntoContext(v8::Isolate *isolate, v8::Local<v8::Context> context) {
    using v8::FunctionTemplate;
    using v8::HandleScope;
    using v8::Local;
    using v8::Object;

    HandleScope scope(isolate);

    Local<FunctionTemplate> tpl = New<FunctionTemplate>();
    tpl->SetClassName(New("Thread").ToLocalChecked());
    tpl->InstanceTemplate()->SetInternalFieldCount(1);

    SetPrototypeMethod(tpl, "postMessage", SendMessageToParent);

    Local<Object> thread_api = tpl->GetFunction()->NewInstance();
    this->Wrap(thread_api);
    thread_api_.Reset(thread_api);

    Local<Object> global = context->Global();
    Set(global, New("thread").ToLocalChecked(), thread_api);
  }

  static NAN_METHOD(SendMessageToParent) {
    ChildThread *thread = Unwrap<ChildThread>(info.This());
  }

private:
  ThreadProxy *thread_;
  Persistent<v8::Object> thread_api_;
};

ThreadProxy::ThreadProxy(const char* filename,
                         const v8::Local<v8::Function> &handle_message) :
                         filename_(filename),
                         handle_message_from_child_(handle_message),
                         child_api_(nullptr),
                         child_env_(nullptr) {
  child_api_ = new ChildThread(this);
  int err;

  uv_sem_init(&child_ready_sem_, 0);

  err = uv_loop_init(&child_loop_);
  if (err != 0) {
    ThrowError("Could not initialize child loop");
  }

  err = uv_thread_create(
    &child_, reinterpret_cast<uv_thread_cb>(ThreadCb), this);
  if (err != 0) {
    ThrowError("Could not create child thread");
  }

  uv_sem_wait(&child_ready_sem_);
}

ThreadProxy::~ThreadProxy() {
  if (child_api_ != nullptr) {
    delete child_api_;
    child_api_ = nullptr;
  }
}

void ThreadProxy::ChildMain() {
  using v8::Context;
  using v8::HandleScope;
  using v8::Isolate;
  using v8::Local;
  using v8::Locker;

  const char* argv[] = { "node", filename_.c_str() };

  Isolate::CreateParams params;
  ArrayBufferAllocator array_buffer_allocator;
  params.array_buffer_allocator = &array_buffer_allocator;
  Isolate* isolate = Isolate::New(params);
  {
    Locker locker(isolate);
    Isolate::Scope isolate_scope(isolate);

    HandleScope handle_scope(isolate);

    Local<Context> context = Context::New(isolate);

    Context::Scope context_scope(context);
    node::Environment *env = child_env_ = node::CreateEnvironment(
        isolate, &child_loop_, context,
        2, argv,
        2, argv);

    child_api_->InjectIntoContext(isolate, context);
    LoadEnvironment(env);

    uv_sem_post(&child_ready_sem_);

    uv_run(&child_loop_, UV_RUN_DEFAULT);

    env = nullptr;
  }
  isolate->Dispose();
}

NAN_MODULE_INIT(ThreadProxy::Init) {
  using v8::FunctionTemplate;
  using v8::Local;
  using v8::String;

  auto className = New("Thread").ToLocalChecked();

  auto tpl = New<FunctionTemplate>(NewInstance);
  tpl->SetClassName(className);
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  SetPrototypeMethod(tpl, "poll", Poll);

  Set(target, className, tpl->GetFunction());
}

NAN_METHOD(ThreadProxy::NewInstance) {
  using v8::Function;
  using v8::Local;
  using v8::String;

  assert(info.IsConstructCall());

  ThreadProxy *thread = new ThreadProxy(*Utf8String(info[0]), info[1].As<Function>());
  thread->Wrap(info.This());
  info.GetReturnValue().Set(info.This());
}

NAN_METHOD(ThreadProxy::Poll) {
  ThreadProxy *thread = Unwrap<ThreadProxy>(info.This());
  info.GetReturnValue().Set(thread == nullptr);
}

NODE_MODULE(DebugThread, ThreadProxy::Init)
