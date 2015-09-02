'use strict';

const BaseAgent = require('../base');

class HeapProfilerAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {boolean=} trackAllocations
   */
  startTrackingHeapObjects() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {boolean=} reportProgress If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken when the tracking is stopped.
   */
  stopTrackingHeapObjects() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {boolean=} reportProgress If true 'reportHeapSnapshotProgress' events will be generated while snapshot is being taken.
   */
  takeHeapSnapshot() {
    throw new Error('Not implemented');
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
  addInspectedHeapObject() {
    throw new Error('Not implemented');
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
