#ifndef __THREAD_H__
#define __THREAD_H__

#include <nan.h>

#include "../deps/fuq/fuq.h"

#include "message-contents.h"

class Thread : public Nan::ObjectWrap {
public:
  Thread(const char* filename, uv_async_t *outbox);
  ~Thread();

  void Start();
  MessageContents *ReadOrNull();

  void EnqueueMessage(MessageContents *contents);

private:
  void Expose(v8::Isolate *isolate, v8::Local<v8::Context> context);

  void Run();
  static void ThreadCb(void *arg);

  static NAN_METHOD(SendMessageToProxy);

  static void ProcessMessages(uv_async_t *handle);
  MessageContents *ReadIncoming();

  std::string filename_;

  uv_thread_t handle_;
  uv_sem_t ready_sem_;
  uv_loop_t loop_;

  fuq_queue_t incoming_;
  fuq_queue_t outgoing_;

  uv_async_t *outbox_;
  uv_async_t inbox_;

  node::Environment *env_;
};

#endif
