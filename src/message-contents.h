#ifndef __MESSAGE_CONTENTS_H__
#define __MESSAGE_CONTENTS_H__

class MessageContents {
public:
  MessageContents(void *data, size_t byteLength) :
    data_(data), byteLength_(byteLength) {}

  inline void *Data() const { return data_; }
  inline size_t ByteLength() const { return byteLength_; }

private:
  void *data_;
  size_t byteLength_;
};

#endif
