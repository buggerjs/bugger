/**
 * Compiled using: -g -Wall -pthread --std=gnu89 -o sporadic -O3 sporadic.c
 */

#include "../fuq.h"
#include <assert.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <inttypes.h>
#include <time.h>

#define ITER 1e7
#define NS 1e9


struct timespec ts_diff(struct timespec start, struct timespec end) {
  struct timespec temp;
  if ((end.tv_nsec - start.tv_nsec) < 0) {
    temp.tv_sec = end.tv_sec - start.tv_sec - 1;
    temp.tv_nsec = NS + (end.tv_nsec - start.tv_nsec);
  } else {
    temp.tv_sec = end.tv_sec - start.tv_sec;
    temp.tv_nsec = end.tv_nsec - start.tv_nsec;
  }
  return temp;
}


static void* task_runner(void* arg) {
  fuq_queue_t* queue;
  struct timespec ts_s;
  struct timespec ts_f;
  uint64_t i;

  clock_gettime(CLOCK_MONOTONIC, &ts_s);

  queue = (fuq_queue_t*) arg;
  for (i = 1; i < ITER; i++) {
    fuq_enqueue(queue, (void*) i);
  }

  clock_gettime(CLOCK_MONOTONIC, &ts_f);
  ts_f= ts_diff(ts_s, ts_f);
  fprintf(stderr,
          "spawned: %zi enqueue/sec\n",
          (unsigned long) (ITER / (ts_f.tv_sec + ts_f.tv_nsec / NS)));

  return NULL;
}


int main(void) {
  fuq_queue_t queue0;
  fuq_queue_t queue1;
  pthread_t thread0;
  pthread_t thread1;
  struct timespec ts_s;
  struct timespec ts_f;
  uint64_t sum0 = 0;
  uint64_t sum1 = 0;
  uint64_t check = 0;
  void* tmp;
  uint64_t i;

  fuq_init(&queue0);
  fuq_init(&queue1);
  assert(pthread_create(&thread0, NULL, task_runner, &queue0) == 0);
  assert(pthread_create(&thread1, NULL, task_runner, &queue1) == 0);

  clock_gettime(CLOCK_MONOTONIC, &ts_s);

  for (i = 1; i < ITER; i++) {
    check += i;
    if (NULL != (tmp = fuq_dequeue(&queue0)))
      sum0 += (uint64_t) tmp;
    if (NULL != (tmp = fuq_dequeue(&queue1)))
      sum1 += (uint64_t) tmp;
  }

  clock_gettime(CLOCK_MONOTONIC, &ts_f);
  ts_f = ts_diff(ts_s, ts_f);

  assert(pthread_join(thread0, NULL) == 0);
  assert(pthread_join(thread1, NULL) == 0);

  fprintf(stderr,
          "parent:  %zi dequeue/sec\n\n",
          (unsigned long) (2 * ITER / (ts_f.tv_sec + ts_f.tv_nsec / NS)));
  fprintf(stderr, "check: %" PRIu64 "\n", check);
  fprintf(stderr, "sum0:  %" PRIu64 "\n", sum0);
  fprintf(stderr, "sum1:  %" PRIu64 "\n", sum1);

  while (!fuq_empty(&queue0))
    sum0 += (uint64_t) fuq_dequeue(&queue0);
  while (!fuq_empty(&queue1))
    sum1 += (uint64_t) fuq_dequeue(&queue1);

  fprintf(stderr, "sum0:  %" PRIu64 "\n", sum0);
  fprintf(stderr, "sum1:  %" PRIu64 "\n", sum1);
  assert(sum0 == check);
  assert(sum1 == check);

  fuq_dispose(&queue0);
  fuq_dispose(&queue1);

  return 0;
}

#undef ITER
#undef NS
