#ifndef __THREAD_PROXY_H__
#define __THREAD_PROXY_H__

#include <nan.h>

#include "thread.h"

class ThreadProxy : public Nan::ObjectWrap {
public:
  static NAN_MODULE_INIT(Init);

private:
  ThreadProxy(const char* filename,
              const v8::Local<v8::Function> &handle_message);
  ~ThreadProxy();

  static NAN_METHOD(NewInstance);
  static NAN_METHOD(Poll);
  static NAN_METHOD(SendMessageToThread);

  static void ProcessMessages(uv_async_t *handle);

  Nan::Callback handle_message_from_thread_;
  Thread thread_;
  uv_async_t inbox_;
};

#endif
