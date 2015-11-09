#ifndef FUQ_WIN_
#define FUQ_WIN_

#include <windows.h>

/* Visual Studio 2012 and above */
#if (_MSC_VER >= 1700)
#include <atomic>

static _fuq_inline void fuq__read_barrier(void) {
  std::atomic_thread_fence(std::memory_order_acquire);
}

static _fuq_inline void fuq__write_barrier(void) {
  std::atomic_thread_fence(std::memory_order_release);
}

/* Visual Studio 2008 and above */
#elif (_MSC_VER >= 1500)
#include <intrin.h>

static _fuq_inline void fuq__read_barrier(void) {
  _ReadBarrier();
}

static _fuq_inline void fuq__write_barrier(void) {
  _WriteBarrier();
}

/* Seriously? */
#else
#error "No supported memory barrier options for this build"
#endif

#endif  /* FUQ_WIN_ */
