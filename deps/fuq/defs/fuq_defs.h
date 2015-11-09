#ifndef FUQ_DEFS_
#define FUQ_DEFS_

/* Include atomic ops for specific compilers and architectures */
#if defined(_MSC_VER)
#include "fuq_win.h"
#elif defined(__powerpc__) || defined(__ppc__) || defined(__PPC__) || \
      defined(__powerpc64__) || defined(__ppc64__) || defined(__PPC64__)
#include "fuq_ppc.h"
#elif defined(__aarch64__)
#include "fuq_arm64.h"
#elif defined(__i386) || defined(_M_IX86) || \
      defined(__x86_64__) || defined(_M_X64)
#include "fuq_x86_32_64.h"
#elif (__GNUC__ > 4) || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1)
#include "fuq_gnuc_generic.h"
#else
#error "No supported memory barrier options for this build"
#endif


#define FUQ_LOAD_PTR(var, exp)                                                \
  do {                                                                        \
    fuq__read_barrier();                                                      \
    (var) = (exp);                                                            \
  } while (0)


#define FUQ_STORE_PTR(queue, ptr)                                             \
  do {                                                                        \
    (queue) = (ptr);                                                          \
    fuq__write_barrier();                                                     \
  } while (0)


#endif  /* FUQ_DEFS_ */
