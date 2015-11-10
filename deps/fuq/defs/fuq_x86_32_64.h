#ifndef FUQ_X86_32_64_
#define FUQ_X86_32_64_

#if defined(__GNUC__)

/* The following taken from
 * http://trac.mpich.org/projects/openpa/browser/src/primitives/opa_gcc_intel_32_64_barrier.h */

/* For all regular memory (write-back cacheable, not driver/graphics
 * memory), there is only one general ordering relaxation permitted by
 * x86/x86_64 processors: earlier stores may be retired after later
 * stores.  The "clflush" and "movnt*" instructions also don't follow
 * general ordering constraints, although any code using these
 * instructions should be responsible for ensuring proper ordering
 * itself.  So our read and write barriers may be implemented as simple
 * compiler barriers. */
static _fuq_inline void fuq__read_barrier(void) {
  __asm__ __volatile__ ("":::"memory");
}

static _fuq_inline void fuq__write_barrier(void) {
  __asm__ __volatile__ ("":::"memory");
}

#else
#error "No supported memory barrier options for this build"
#endif

#endif  /* FUQ_X86_32_64_ */
