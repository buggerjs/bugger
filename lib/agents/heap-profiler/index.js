'use strict';

const profiler = require('v8-profiler');

const BaseAgent = require('../base');

class HeapProfilerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   */
  enable() {
  }

  /**
   */
  disable() {
  }

  /**
   *
   * @param {boolean=} trackAllocations
   */
  startTrackingHeapObjects(params) {
    profiler.startTrackingHeapObjects(params.trackAllocations);
  }

  /**
   *
   * @param {boolean=} reportProgress If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken when the tracking is stopped.
   */
  stopTrackingHeapObjects(params) {
    return new Promise(resolve => {
      const handleSamples = samples => {
        this.emit('heapStatsUpdate', { statsUpdate: samples });
      };
      profiler.getHeapStats(handleSamples, () => {
        profiler.stopTrackingHeapObjects();
        resolve(this.takeHeapSnapshot(params));
      });
    });
  }

  /**
   *
   * @param {boolean=} reportProgress If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
   */
  takeHeapSnapshot(params) {
    const reportProgress = !!params.reportProgress;

    const reportHeapSnapshotProgress = (done, total) => {
      this.emit('reportHeapSnapshotProgress', {
        done: done,
        total: total,
        finished: done === total,
      });
    };

    const addHeapSnapshotChunk = chunk => {
      this.emit('addHeapSnapshotChunk', { chunk: chunk });
    };

    return new Promise(resolve => {
      const snapshot = profiler.takeSnapshot(reportProgress ? reportHeapSnapshotProgress : false);

      snapshot.serialize(addHeapSnapshotChunk, () => {
        snapshot.delete();
        resolve();
      });
    });
  }

  /**
   */
  collectGarbage() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {HeapSnapshotObjectId} objectId
   * @param {string=} objectGroup Symbolic group name that can be used to release multiple objects.
   *
   * @returns {Runtime.RemoteObject} result Evaluation result.
   */
  getObjectByHeapObjectId() {
    throw new Error('Not implemented');
  }

  /**
   * Enables console to refer to the node with given id via $x (see Command Line API for more details $x functions).
   *
   * @param {HeapSnapshotObjectId} heapObjectId Heap snapshot object id to be accessible by means of $x command line API.
   */
  addInspectedHeapObject(params) {
    this._ignore('addInspectedHeapObject', params);
  }

  /**
   *
   * @param {Runtime.RemoteObjectId} objectId Identifier of the object to get heap object id for.
   *
   * @returns {HeapSnapshotObjectId} heapSnapshotObjectId Id of the heap snapshot object corresponding to the passed remote object id.
   */
  getHeapObjectId() {
    throw new Error('Not implemented');
  }
}

module.exports = HeapProfilerAgent;
