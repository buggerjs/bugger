#include "thread.h"

using namespace Nan;

class ArrayBufferAllocator : public v8::ArrayBuffer::Allocator {
public:
  virtual void* Allocate(size_t length) {
    void *data = AllocateUninitialized(length);
    return data == NULL ? data : memset(data, 0, length);
  }
  virtual void* AllocateUninitialized(size_t length) { return malloc(length); }
  virtual void Free(void* data, size_t) { free(data); }
};

Thread::Thread(const char* filename,
               std::vector<std::string> args,
               uv_async_t *outbox)
: filename_(filename), args_(args), outbox_(outbox) {
  uv_sem_init(&ready_sem_, 0);
  uv_sem_init(&outbox_sem_, 0);

  fuq_init(&incoming_);
  fuq_init(&outgoing_);

  int err = uv_loop_init(&loop_);
  if (err != 0) {
    ThrowError("Could not initialize child loop");
  }

  uv_async_init(&loop_, &inbox_, ProcessMessages);
  inbox_.data = (void*) this;
}

Thread::~Thread() {
}

void Thread::Start() {
  int err = uv_thread_create(
    &handle_, reinterpret_cast<uv_thread_cb>(ThreadCb), this);
  if (err != 0) {
    ThrowError("Could not create child thread");
  }

  uv_sem_wait(&ready_sem_);
}

void Thread::EnqueueMessage(MessageContents *contents) {
  fuq_enqueue(&incoming_, (void*) contents);
  uv_async_send(&inbox_);
}

void Thread::ProcessMessages(uv_async_t *async) {
  using v8::Function;
  using v8::Local;
  using v8::Object;
  using v8::Value;

  HandleScope handleScope;
  Thread *thread = static_cast<Thread*>(async->data);

  // Get message event handler
  Local<Object> api(thread->handle());
  Local<Value> kOnMessage(New("onMessage").ToLocalChecked());
  Callback onMessage(Get(api, kOnMessage).ToLocalChecked().As<Function>());

  MessageContents *contents;
  while ((contents = thread->ReadIncoming()) != nullptr) {
    char *charData = static_cast<char*>(contents->Data());
    v8::Local<v8::Object> buffer(
      NewBuffer(charData, contents->ByteLength())
        .ToLocalChecked());
    v8::Local<v8::Value> argv[] = { buffer };
    onMessage.Call(api, 1, argv);
  }
}

NAN_METHOD(Thread::SendMessageToProxy) {
  using v8::ArrayBufferView;
  using v8::Local;

  Local<ArrayBufferView> view(info[0].As<ArrayBufferView>());

  auto length = view->ByteLength();
  auto contents = new MessageContents(malloc(length), length);
  view->CopyContents(contents->Data(), length);

  Thread *thread = Unwrap<Thread>(info.This());
  fuq_enqueue(&thread->outgoing_, (void*) contents);
  uv_sem_post(&thread->outbox_sem_);
  uv_async_send(thread->outbox_);
}

MessageContents *Thread::ReadOrBlock() {
  // Block until we have a message.
  MessageContents *contents;
  do {
    uv_sem_wait(&outbox_sem_);
    contents = static_cast<MessageContents*>(fuq_dequeue(&outgoing_));
  } while (contents == nullptr);

  return contents;
}

MessageContents *Thread::ReadOrNull() {
  int err = uv_sem_trywait(&outbox_sem_);
  if (err != 0) {
    return nullptr;
  }
  // We are allowed to take something from the queue
  return static_cast<MessageContents*>(fuq_dequeue(&outgoing_));
}

MessageContents *Thread::ReadIncoming() {
  return static_cast<MessageContents*>(fuq_dequeue(&incoming_));
}

void Thread::Expose(v8::Isolate *isolate, v8::Local<v8::Context> context) {
  using v8::FunctionTemplate;
  using v8::HandleScope;
  using v8::Local;
  using v8::Object;

  HandleScope scope(isolate);

  Local<FunctionTemplate> tpl = New<FunctionTemplate>();
  tpl->SetClassName(New("Thread").ToLocalChecked());
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  SetPrototypeMethod(tpl, "postMessage", SendMessageToProxy);

  Local<Object> thread_api = tpl->GetFunction()->NewInstance();
  this->Wrap(thread_api);

  Local<Object> global = context->Global();
  Set(global, New("thread").ToLocalChecked(), thread_api);
}

void Thread::ThreadCb(void *arg) {
  static_cast<Thread*>(arg)->Run();
}

void Thread::Run() {
  using v8::Context;
  using v8::HandleScope;
  using v8::Isolate;
  using v8::Local;
  using v8::Locker;

  std::vector<const char*> argv;
  argv.push_back("node");
  argv.push_back(filename_.c_str());
  for (size_t idx = 0; idx < args_.size(); ++idx) {
    argv.push_back(args_[idx].c_str());
  }

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
    env_ = node::CreateEnvironment(
        isolate, &loop_, context,
        argv.size(), argv.data(),
        argv.size(), argv.data());

    Expose(isolate, context);
    LoadEnvironment(env_);

    uv_sem_post(&ready_sem_);

    uv_run(&loop_, UV_RUN_DEFAULT);

    env_ = nullptr;
  }
  isolate->Dispose();
}
