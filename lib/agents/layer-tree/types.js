'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Unique Layer identifier.
   */
exports.LayerId = String;

  /**
   * Unique snapshot identifier.
   */
exports.SnapshotId = String;

  /**
   * Rectangle where scrolling happens on the main thread.
   *
   * @param {DOM.Rect} rect Rectangle itself.
   * @param {string RepaintsOnScroll|TouchEventHandler|WheelEventHandler} type Reason for rectangle to force scrolling on the main thread
   */
exports.ScrollRect =
function ScrollRect(props) {
  this.rect = props.rect;
  this.type = props.type;
};

  /**
   * Serialized fragment of layer picture along with its offset within the layer.
   *
   * @param {number} x Offset from owning layer left boundary
   * @param {number} y Offset from owning layer top boundary
   * @param {string} picture Base64-encoded snapshot data.
   */
exports.PictureTile =
function PictureTile(props) {
  this.x = props.x;
  this.y = props.y;
  this.picture = props.picture;
};

  /**
   * Information about a compositing layer.
   *
   * @param {LayerId} layerId The unique id for this layer.
   * @param {LayerId=} parentLayerId The id of parent (not present for root).
   * @param {DOM.BackendNodeId=} backendNodeId The backend id for the node associated with this layer.
   * @param {number} offsetX Offset from parent layer, X coordinate.
   * @param {number} offsetY Offset from parent layer, Y coordinate.
   * @param {number} width Layer width.
   * @param {number} height Layer height.
   * @param {Array.<number>=} transform Transformation matrix for layer, default is identity matrix
   * @param {number=} anchorX Transform anchor point X, absent if no transform specified
   * @param {number=} anchorY Transform anchor point Y, absent if no transform specified
   * @param {number=} anchorZ Transform anchor point Z, absent if no transform specified
   * @param {integer} paintCount Indicates how many time this layer has painted.
   * @param {boolean} drawsContent Indicates whether this layer hosts any content, rather than being used for transform/scrolling purposes only.
   * @param {boolean=} invisible Set if layer is not visible.
   * @param {Array.<ScrollRect>=} scrollRects Rectangles scrolling on main thread only.
   */
exports.Layer =
function Layer(props) {
  this.layerId = props.layerId;
  this.parentLayerId = props.parentLayerId;
  this.backendNodeId = props.backendNodeId;
  this.offsetX = props.offsetX;
  this.offsetY = props.offsetY;
  this.width = props.width;
  this.height = props.height;
  this.transform = props.transform;
  this.anchorX = props.anchorX;
  this.anchorY = props.anchorY;
  this.anchorZ = props.anchorZ;
  this.paintCount = props.paintCount;
  this.drawsContent = props.drawsContent;
  this.invisible = props.invisible;
  this.scrollRects = props.scrollRects;
};

  /**
   * Array of timings, one per paint step.
   */
exports.PaintProfile = function PaintProfile(arr) { return arr; };
