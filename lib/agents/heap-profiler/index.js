'use strict';

const profiler = require('v8-profiler');

const BaseAgent = require('../base');
const cliAPI = require('../cli-api');
const ObjectGroup = require('../object-group');

class HeapTracker {
  constructor(agent) {
    this._agent = agent;

    this._running = false;
    this._timer = null;
    this._lastSeenObjectId = null;
    this._samples = [];
  }

  _flush() {
    this._agent.emit('heapStatsUpdate', {
      statsUpdate: this._samples,
    });
    this._agent.emit('lastSeenObjectId', {
      lastSeenObjectId: this._lastSeenObjectId,
      timestamp: Date.now(),
    });
    this._samples = [];
  }

  _getStats() {
    if (!this._running) return;

    const onUpdate = (samples) => {
      if (!this._running) return false;
      this._samples = this._samples.concat(samples);
    };

    const onDone = () => {
      if (!this._running) return false;
      this._flush();
      this._timer = setTimeout(() => this._getStats(), 100);
    };

    this._lastSeenObjectId = profiler.getHeapStats(onUpdate, onDone);
  }

  start() {
    this._running = true;
    profiler.startTrackingHeapObjects();
    this._getStats();
  }

  stop() {
    this._running = false;
    clearTimeout(this._timer);
    this._timer = null;
    profiler.stopTrackingHeapObjects();
  }
}

class HeapProfilerAgent extends BaseAgent {
  constructor() {
    super();
    this._heapTracker = null;

    this._resetCaches();
  }

  /**
   */
  enable() {
    this._resetCaches();
  }

  /**
   */
  disable() {
    this._resetCaches();
  }

  _resetCaches() {
    this._objectIdToHeapObjectId = {};
  }

  /**
   *
   * @param {boolean=} trackAllocations
   */
  startTrackingHeapObjects() {
    if (this._heapTracker !== null) {
      this._heapTracker.stop();
      this._heapTracker = null;
    }
    const heapTracker = this._heapTracker = new HeapTracker(this);
    heapTracker.start();
  }

  /**
   *
   * @param {boolean=} reportProgress If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken when the tracking is stopped.
   */
  stopTrackingHeapObjects(params) {
    const heapTracker = this._heapTracker;
    if (!heapTracker) {
      throw new Error('startTrackingHeapObjects not called first');
    }
    heapTracker.stop();
    return this.takeHeapSnapshot(params);
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
  getObjectByHeapObjectId(params) {
    const object = profiler.getObjectByHeapObjectId(+params.objectId);
    const result = ObjectGroup.add('@heap-profiler', object);
    if (result.objectId) {
      this._objectIdToHeapObjectId[result.objectId] = params.objectId;
    }
    return { result };
  }

  /**
   * Enables console to refer to the node with given id via $x (see Command Line API for more details $x functions).
   *
   * @param {HeapSnapshotObjectId} heapObjectId Heap snapshot object id to be accessible by means of $x command line API.
   */
  addInspectedHeapObject(params) {
    const object = profiler.getObjectByHeapObjectId(+params.heapObjectId);
    cliAPI.addToRingBuffer(object);
  }

  /**
   *
   * @param {Runtime.RemoteObjectId} objectId Identifier of the object to get heap object id for.
   *
   * @returns {HeapSnapshotObjectId} heapSnapshotObjectId Id of the heap snapshot object corresponding to the passed remote object id.
   */
  getHeapObjectId(params) {
    const heapSnapshotObjectId = this._objectIdToHeapObjectId[params.objectId];
    return { heapSnapshotObjectId };
  }
}

module.exports = HeapProfilerAgent;
