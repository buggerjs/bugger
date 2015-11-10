#include "thread-proxy.h"

using namespace Nan;

ThreadProxy::ThreadProxy(const char* filename,
                         const v8::Local<v8::Function> &handle_message) :
                         handle_message_from_thread_(handle_message),
                         thread_(filename, &inbox_) {
  uv_async_init(uv_default_loop(), &inbox_, ProcessMessages);
  inbox_.data = (void*) this;

  thread_.Start();
}

ThreadProxy::~ThreadProxy() {
}

void ThreadProxy::ProcessMessages(uv_async_t *handle) {
  HandleScope handleScope;
  ThreadProxy *proxy = static_cast<ThreadProxy*>(handle->data);

  MessageContents *contents;
  while ((contents = proxy->thread_.ReadOrNull()) != nullptr) {
    char *charData = static_cast<char*>(contents->Data());
    v8::Local<v8::Object> buffer(
      NewBuffer(charData, contents->ByteLength())
        .ToLocalChecked());
    v8::Local<v8::Value> argv[] = { buffer };
    proxy->handle_message_from_thread_.Call(1, argv);
  }
}

NAN_MODULE_INIT(ThreadProxy::Init) {
  using v8::FunctionTemplate;
  using v8::Local;
  using v8::String;

  auto className = New("ThreadProxy").ToLocalChecked();

  auto tpl = New<FunctionTemplate>(NewInstance);
  tpl->SetClassName(className);
  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  SetPrototypeMethod(tpl, "poll", Poll);
  SetPrototypeMethod(tpl, "postMessage", SendMessageToThread);

  Set(target, className, tpl->GetFunction());
}

NAN_METHOD(ThreadProxy::NewInstance) {
  using v8::Function;
  using v8::Local;
  using v8::String;

  assert(info.IsConstructCall());

  ThreadProxy *proxy = new ThreadProxy(*Utf8String(info[0]), info[1].As<Function>());
  proxy->Wrap(info.This());
  info.GetReturnValue().Set(info.This());
}

NAN_METHOD(ThreadProxy::SendMessageToThread) {
  using v8::ArrayBufferView;
  using v8::Local;

  Local<ArrayBufferView> view(info[0].As<ArrayBufferView>());

  auto length = view->ByteLength();
  auto contents = new MessageContents(malloc(length), length);
  view->CopyContents(contents->Data(), length);

  ThreadProxy *proxy = Unwrap<ThreadProxy>(info.This());
  proxy->thread_.EnqueueMessage(contents);
}

NAN_METHOD(ThreadProxy::Poll) {
  ThreadProxy *proxy = Unwrap<ThreadProxy>(info.This());
  auto contents = proxy->thread_.ReadOrBlock();

  char *charData = static_cast<char*>(contents->Data());
  v8::Local<v8::Object> buffer(
    NewBuffer(charData, contents->ByteLength())
      .ToLocalChecked());

  info.GetReturnValue().Set(buffer);
}
