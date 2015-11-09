#ifndef FUQ_ARM64_
#define FUQ_ARM64_

#if defined(__GNUC__)

static _fuq_inline void fuq__read_barrier(void) {
  __asm__ __volatile__ ("dmb ishld":::"memory");
}

static _fuq_inline void fuq__write_barrier(void) {
  __asm__ __volatile__ ("dmb ishst":::"memory");
}

#else
#error "No supported memory barrier options for this build"
#endif

#endif  /* FUQ_ARM64_ */
