'use strict';

const BaseAgent = require('../base');

class LayerTreeAgent extends BaseAgent {
  constructor() {
    super();
  }

  /**
   * Enables compositing tree inspection.
   */
  enable() {
    throw new Error('Not implemented');
  }

  /**
   * Disables compositing tree inspection.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Provides the reasons why the given layer was composited.
   *
   * @param {LayerId} layerId The id of the layer for which we want to get the reasons it was composited.
   *
   * @returns {Array.<string>} compositingReasons A list of strings specifying reasons for the given layer to become composited.
   */
  compositingReasons() {
    throw new Error('Not implemented');
  }

  /**
   * Returns the layer snapshot identifier.
   *
   * @param {LayerId} layerId The id of the layer.
   *
   * @returns {SnapshotId} snapshotId The id of the layer snapshot.
   */
  makeSnapshot() {
    throw new Error('Not implemented');
  }

  /**
   * Returns the snapshot identifier.
   *
   * @param {Array.<PictureTile>} tiles An array of tiles composing the snapshot.
   *
   * @returns {SnapshotId} snapshotId The id of the snapshot.
   */
  loadSnapshot() {
    throw new Error('Not implemented');
  }

  /**
   * Releases layer snapshot captured by the back-end.
   *
   * @param {SnapshotId} snapshotId The id of the layer snapshot.
   */
  releaseSnapshot() {
    throw new Error('Not implemented');
  }

  /**
   *
   * @param {SnapshotId} snapshotId The id of the layer snapshot.
   * @param {integer=} minRepeatCount The maximum number of times to replay the snapshot (1, if not specified).
   * @param {number=} minDuration The minimum duration (in seconds) to replay the snapshot.
   * @param {DOM.Rect=} clipRect The clip rectangle to apply when replaying the snapshot.
   *
   * @returns {Array.<PaintProfile>} timings The array of paint profiles, one per run.
   */
  profileSnapshot() {
    throw new Error('Not implemented');
  }

  /**
   * Replays the layer snapshot and returns the resulting bitmap.
   *
   * @param {SnapshotId} snapshotId The id of the layer snapshot.
   * @param {integer=} fromStep The first step to replay from (replay from the very start if not specified).
   * @param {integer=} toStep The last step to replay to (replay till the end if not specified).
   * @param {number=} scale The scale to apply while replaying (defaults to 1).
   *
   * @returns {string} dataURL A data: URL for resulting image.
   */
  replaySnapshot() {
    throw new Error('Not implemented');
  }

  /**
   * Replays the layer snapshot and returns canvas log.
   *
   * @param {SnapshotId} snapshotId The id of the layer snapshot.
   *
   * @returns {Array.<Object>} commandLog The array of canvas function calls.
   */
  snapshotCommandLog() {
    throw new Error('Not implemented');
  }
}

module.exports = new LayerTreeAgent();
