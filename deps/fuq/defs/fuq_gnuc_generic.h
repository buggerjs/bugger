#ifndef FUQ_GNUC_GENERIC_
#define FUQ_GNUC_GENERIC_

static _fuq_inline void fuq__read_barrier(void) {
  __sync_synchronize();
}

static _fuq_inline void fuq__write_barrier(void) {
  __sync_synchronize();
}

#endif  /* FUQ_GNUC_GENERIC_ */
