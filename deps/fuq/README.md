# fuq.h

## Overview

`fuq` stands for a <b>F</b>undamentally <b>U</b>nstable <b>Q</b>ueue. It is a
thread safe, lock-free SPSC (single producer single consumer) queue written in
C.

This code started as an academic experiment and eventually turned into a
working API. Because of the difficulty to properly test, it is permanently
marked as unstable. Though, while only tested on Linux, results have been
consistent under prolonged heavy load.

Being SPSC means only a single thread can push items onto the queue, and
only one thread can shift items from the queue. Ownership of which thread does
each operation can be transferred between threads, but take special care that
only a single thread is allowed to perform each operation at any given time.

Community involvement for further testing and hardening is highly encouraged.


## API

[`fuq_queue`](#fuq_queue)<br>
[`fuq_init`](#void-fuq_initfuq_queue-queue)<br>
[`fuq_push`](#void-fuq_pushfuq_queue-queue-void-arg)<br>
[`fuq_shift`](#void-fuq_shiftfuq_queue-queue)<br>
[`fuq_dispose`](#void-fuq_disposefuq_queue-queue)

The API has been made minimal and straightforward as possible. The author's
background in JS influenced the naming convention. Using push and shift,
following the
[JS Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array)
convention.


##### `fuq_queue`

The memory construct that contains all the information about an individual
queue. For convenience this `struct` is `typedef`'d.

To prevent unnecessary memory allocations the queue allocates a slab that is
used to store pointers to all the queue items. Defined by `FUQ_ARRAY_SIZE`, the
default size is 511. This is to round out at 512 slots, because 1 slot is added
when allocated. The final slot is a pointer to the next slab of queue items. In
the case the queue overflows the slab size.

Further unnecessary memory allocation are prevented by storing references to
previously allocated slabs not in use. Please note, in order to maintain a
lock-free queue these unused slabs are not pooled between all active
`fuq_queue` instances. Instead each instance contains a linked list of all its
own unused slabs. So remember that
[properly disposing](#void-fuq_disposefuq_queue) of the queue at its end of
life is important to cleanup all the linked unused slabs.

To ensure a single instance isn't allowed to store too many slabs, there is a
maximum allowed number of slabs that can be stored. Defined by `FUQ_MAX_STOR`,
the default value is 1024.


##### `void fuq_init(fuq_queue* queue)`

Pass an uninitialized `fuq_queue` instance. Instances that have been passed to
[`fuq_dispose`](#void-fuq_disposefuq_queue-queue) are considered uninitialized.

On initialization the initial slab is allocated, and pointers are appropriately
set. All these are necessary in order to allow each push and shift to be
done in a single instruction.


##### `void fuq_push(fuq_queue* queue, void* arg)`

Place a single `void* arg` onto the queue. This can be done at any time without
the need to lock the queue.


##### `void* fuq_shift(fuq_queue* queue)`

Returns the next item in the queue. If there are no more items in the queue
then `NULL` will be returned. Even so, it is still possible for `NULL` to be
pushed onto the queue without disrupting normal activity. It simply may cause
confusion that the queue is empty.


##### `void fuq_dispose(fuq_queue* queue)`

Frees all allocated slabs _and_ stored pointers. The moment this function runs
the queue should be considered uninitialized, and no other pulls or shifts
should be run on the queue. Though the queue is not fully uninitialized until
the function returns.


## Example

The following example uses `pthread` to quickly push and shift values from the
queue. This is not an excellent showcase, but at least very simple.

```c
/**
 * Compiled using: -g -Wall -pthread -o sporadic -O3 sporadic.c
 */

#include "./fuq.h"
#include <assert.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>

#define ITER 1e7

fuq_queue queue;
pthread_t thread;


static void* task_runner(void* arg) {
  size_t i;

  /* Pushing values onto the queue as fast as possible. */
  for (i = 1; i < ITER; i++)
    fuq_push(&queue, (void*) i);
  return NULL;
}


int main(void) {
  uint64_t sum = 0;
  uint64_t check = 0;
  void* tmp;
  size_t i;

  fuq_init(&queue);
  assert(pthread_create(&thread, NULL, task_runner, NULL) == 0);

  /* Notice i starts at 1, because 0x0 == NULL. */
  for (i = 1; i < ITER; i++) {
    /* To make sure the final sum is correct. */
    check += i;
    /* Grab a value from the queue. */
    if (NULL != (tmp = fuq_shift(&queue)))
      sum += (uint64_t) tmp;
  }

  fprintf(stderr, "check: %zi\n", check);
  fprintf(stderr, "sum:   %zi\n", sum);

  assert(pthread_join(thread, NULL) == 0);

  /* Finish getting the remaining values from the queue. */
  while (NULL != (tmp = fuq_shift(&queue)))
    sum += (uint64_t) tmp;

  fprintf(stderr, "sum:   %zi\n", sum);
  assert(sum == check);

  fuq_dispose(&queue);
}
```
