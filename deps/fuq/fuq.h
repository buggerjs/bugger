/**
 * fuq - a Fundamentally Unstable Queue
 *
 * fuq handles single consumer, single producer scenarios where only one
 * thread is pushing data to the queue and another is shifting out.
 *
 * There is the case of a "false negative". Meaning an item can be in process
 * of being pushed into the queue while the other end is shifting data out
 * and receives NULL. Indicating that the queue is empty.
 */

#ifndef FUQ_H_
#define FUQ_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>  /* malloc, free */
#include <stdio.h>   /* fprintf, fflush */

/* Prevent warnings when compiled with --std=gnu89 -pedantic */
#if defined (__STRICT_ANSI__) || defined (__GNUC_GNU_INLINE__)
# define _fuq_inline __inline__
#else
# define _fuq_inline inline
#endif

#include "defs/fuq_defs.h"

/* Usual page size minus 1 */
#define FUQ_ARRAY_SIZE 4095
/* Single queue is allowed max of 32KB memory retention */
#define FUQ_MAX_STOR 4

/* The last slot is reserved as a pointer to the next fuq__array. */
typedef void* fuq__array[FUQ_ARRAY_SIZE + 1];

typedef struct {
  fuq__array* head_array;
  fuq__array* tail_array;
  int head_idx;
  int tail_idx;
  /* These are key to allowing single atomic operations. */
  void** head;
  volatile void** tail;
  /* Storage containers for unused allocations. */
  fuq__array* head_stor;
  volatile fuq__array* tail_stor;
  /* Number of fuq__array's currently stored. */
  int max_stor;
} fuq_queue_t;


#if defined(DEBUG)
#define FUQ_CHECK_OOM(pntr)                                                   \
  do {                                                                        \
    if (NULL != pntr) continue;                                               \
    fprintf(stderr, "FATAL: OOM - %s:%i\n", __FILE__, __LINE__);              \
    fflush(stderr);                                                           \
    abort();                                                                  \
  } while (0)
#else
#define FUQ_CHECK_OOM(pntr)
#endif


static _fuq_inline fuq__array* fuq__alloc_array(fuq_queue_t* queue) {
  fuq__array* array;
  volatile fuq__array* tail_stor;

  FUQ_LOAD_PTR(tail_stor, queue->tail_stor);

  if ((fuq__array*) tail_stor == queue->head_stor) {
    array = (fuq__array*) malloc(sizeof(*array));
    FUQ_CHECK_OOM(array);
  } else {
    array = queue->head_stor;
    queue->head_stor = (fuq__array*) (*array)[1];
    queue->max_stor -= 1;
  }

  return array;
}


static _fuq_inline void fuq__free_array(fuq_queue_t* queue, fuq__array* array) {
  if (FUQ_MAX_STOR > queue->max_stor) {
    free((void*) array);
    return;
  }

  (*array)[1] = NULL;
  (*queue->tail_stor)[1] = array;
  queue->max_stor += 1;

  FUQ_STORE_PTR(queue->tail_stor, (volatile fuq__array*) array);
}


static _fuq_inline void fuq_init(fuq_queue_t* queue) {
  fuq__array* array;
  fuq__array* stor;

  array = (fuq__array*) malloc(sizeof(*array));
  FUQ_CHECK_OOM(array);
  stor = (fuq__array*) malloc(sizeof(*stor));
  FUQ_CHECK_OOM(stor);
  /* Initialize in case fuq_dispose() is called immediately after fuq_init(). */
  (*stor)[1] = NULL;

  queue->head_array = array;
  queue->tail_array = array;
  queue->head_idx = 0;
  queue->tail_idx = 0;
  queue->head = &(**array);
  queue->tail = (volatile void**) &(**array);
  queue->head_stor = stor;
  queue->tail_stor = (volatile fuq__array*) stor;
  queue->max_stor = 0;
}


static _fuq_inline int fuq_empty(fuq_queue_t* queue) {
  volatile void** tail;
  FUQ_LOAD_PTR(tail, queue->tail);
  return queue->head == (void**) tail;
}


static _fuq_inline void fuq_enqueue(fuq_queue_t* queue, void* arg) {
  fuq__array* array;
  volatile void* tail;

  *queue->tail = arg;
  queue->tail_idx += 1;

  if (FUQ_ARRAY_SIZE > queue->tail_idx) {
    tail = &((*queue->tail_array)[queue->tail_idx]);
    FUQ_STORE_PTR(queue->tail, (volatile void**) tail);
    return;
  }

  array = fuq__alloc_array(queue);
  (*queue->tail_array)[queue->tail_idx] = (void*) array;
  queue->tail_array = array;
  queue->tail_idx = 0;

  tail = &(**array);
  FUQ_STORE_PTR(queue->tail, (volatile void**) tail);
}


static _fuq_inline void* fuq_dequeue(fuq_queue_t* queue) {
  fuq__array* next_array;
  void* ret;

  if (fuq_empty(queue))
    return NULL;

  ret = *queue->head;
  queue->head_idx += 1;
  queue->head = &((*queue->head_array)[queue->head_idx]);

  if (FUQ_ARRAY_SIZE > queue->head_idx)
    return ret;

  next_array = (fuq__array*) *queue->head;
  fuq__free_array(queue, queue->head_array);
  queue->head = &(**next_array);
  queue->head_array = next_array;
  queue->head_idx = 0;

  return ret;
}


/* Useful for cleanup at end of applications life to make valgrind happy. */
static _fuq_inline void fuq_dispose(fuq_queue_t* queue) {
  void* next_array;

  while (queue->head_array != queue->tail_array) {
    next_array = (*queue->head_array)[FUQ_ARRAY_SIZE];
    free((void*) queue->head_array);
    queue->head_array = (fuq__array*) next_array;
  }

  free((void*) queue->head_array);

  if (NULL == queue->head_stor)
    return;

  do {
    next_array = (*queue->head_stor)[1];
    free((void*) queue->head_stor);
    queue->head_stor = (fuq__array*) next_array;
  } while (NULL != next_array);
}


#undef FUQ_ARRAY_SIZE
#undef FUQ_CHECK_OOM
#undef FUQ_MAX_STOR
#undef FUQ_STORE_PTR

#ifdef __cplusplus
}
#endif
#endif  /* FUQ_H_ */
