'use strict';
// This file is auto-generated using scripts/doc-sync.js

  /**
   * Animation instance.
   *
   * @param {string} id <code>Animation</code>'s id.
   * @param {boolean} pausedState <code>Animation</code>'s internal paused state.
   * @param {string} playState <code>Animation</code>'s play state.
   * @param {number} playbackRate <code>Animation</code>'s playback rate.
   * @param {number} startTime <code>Animation</code>'s start time.
   * @param {number} currentTime <code>Animation</code>'s current time.
   * @param {AnimationEffect} source <code>Animation</code>'s source animation node.
   * @param {string CSSTransition|CSSAnimation|WebAnimation} type Animation type of <code>Animation</code>.
   */
exports.Animation =
function Animation(props) {
  this.id = props.id;
  this.pausedState = props.pausedState;
  this.playState = props.playState;
  this.playbackRate = props.playbackRate;
  this.startTime = props.startTime;
  this.currentTime = props.currentTime;
  this.source = props.source;
  this.type = props.type;
};

  /**
   * AnimationEffect instance
   *
   * @param {number} delay <code>AnimationEffect</code>'s delay.
   * @param {number} endDelay <code>AnimationEffect</code>'s end delay.
   * @param {number} playbackRate <code>AnimationEffect</code>'s playbackRate.
   * @param {number} iterationStart <code>AnimationEffect</code>'s iteration start.
   * @param {number} iterations <code>AnimationEffect</code>'s iterations.
   * @param {number} duration <code>AnimationEffect</code>'s iteration duration.
   * @param {string} direction <code>AnimationEffect</code>'s playback direction.
   * @param {string} fill <code>AnimationEffect</code>'s fill mode.
   * @param {string} name <code>AnimationEffect</code>'s name.
   * @param {DOM.BackendNodeId} backendNodeId <code>AnimationEffect</code>'s target node.
   * @param {KeyframesRule=} keyframesRule <code>AnimationEffect</code>'s keyframes.
   * @param {string} easing <code>AnimationEffect</code>'s timing function.
   */
exports.AnimationEffect =
function AnimationEffect(props) {
  this.delay = props.delay;
  this.endDelay = props.endDelay;
  this.playbackRate = props.playbackRate;
  this.iterationStart = props.iterationStart;
  this.iterations = props.iterations;
  this.duration = props.duration;
  this.direction = props.direction;
  this.fill = props.fill;
  this.name = props.name;
  this.backendNodeId = props.backendNodeId;
  this.keyframesRule = props.keyframesRule;
  this.easing = props.easing;
};

  /**
   * Keyframes Rule
   *
   * @param {string=} name CSS keyframed animation's name.
   * @param {Array.<KeyframeStyle>} keyframes List of animation keyframes.
   */
exports.KeyframesRule =
function KeyframesRule(props) {
  this.name = props.name;
  this.keyframes = props.keyframes;
};

  /**
   * Keyframe Style
   *
   * @param {string} offset Keyframe's time offset.
   * @param {string} easing <code>AnimationEffect</code>'s timing function.
   */
exports.KeyframeStyle =
function KeyframeStyle(props) {
  this.offset = props.offset;
  this.easing = props.easing;
};
