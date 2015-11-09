#include <nan.h>
#include <v8-debug.h>

#include "../deps/fuq/fuq.h"

using namespace Nan;

class DebugThread : public Nan::ObjectWrap {
public:
  static NAN_MODULE_INIT(Init);

private:
  DebugThread(const char* filename,
              const v8::Local<v8::Function> &handle_message);
  ~DebugThread();

  static NAN_METHOD(NewInstance);
  static NAN_METHOD(Poll);

  static void ThreadCb(void *arg) {
    static_cast<DebugThread*>(arg)->ThreadMain();
  }
  void ThreadMain();

  std::string filename_;
  Callback handle_message_from_thread_;

  uv_thread_t thread_;
  uv_sem_t thread_ready_sem_;
};

DebugThread::DebugThread(const char* filename,
                         const v8::Local<v8::Function> &handle_message) :
                         filename_(filename),
                         handle_message_from_thread_(handle_message) {
  int err;

  uv_sem_init(&thread_ready_sem_, 0);

  err = uv_thread_create(
    &thread_, reinterpret_cast<uv_thread_cb>(ThreadCb), this);
  if (err != 0) {
    // TODO: Error handling?
  }

  uv_sem_wait(&thread_ready_sem_);
}

DebugThread::~DebugThread() {}

void DebugThread::ThreadMain() {
  uv_sem_post(&thread_ready_sem_);
}

NAN_MODULE_INIT(DebugThread::Init) {
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

NAN_METHOD(DebugThread::NewInstance) {
  using v8::Function;
  using v8::Local;
  using v8::String;

  assert(info.IsConstructCall());

  Utf8String filename(info[0]);
  Local<Function> handle_message(info[1].As<Function>());

  DebugThread *thread = new DebugThread(*filename, handle_message);
  thread->Wrap(info.This());
  info.GetReturnValue().Set(info.This());
}

NAN_METHOD(DebugThread::Poll) {
  DebugThread *thread = Unwrap<DebugThread>(info.This());
  info.GetReturnValue().Set(thread == nullptr);
}

NODE_MODULE(DebugThread, DebugThread::Init)
