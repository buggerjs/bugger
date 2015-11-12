'use strict';

const _ = require('lodash');
const profiler = require('v8-profiler');

const UrlMapper = require('../../url-mapper');

const BaseAgent = require('../base');

function fixProfileNode(node) {
  const url = node.url;
  if (url && !/^\w+:\/\//.test(url)) {
    // url does not have a protocol
    node.url = UrlMapper.scriptUrlFromName(url);
  }
  _.each(node.children || [], fixProfileNode);
}

function fixFileReferences(profile) {
  if (profile) {
    fixProfileNode(profile.head);
  }
  return profile;
}

class ProfilerAgent extends BaseAgent {
  constructor() {
    super();

    this._lastIdx = 0;
    this._lastName = null;
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
   * Changes CPU profiler sampling interval.
   * Must be called before CPU profiles recording started.
   *
   * @param {integer} interval New sampling interval in microseconds.
   */
  setSamplingInterval(params) {
    // TODO: Update FLAG_cpu_profiler_sampling_interval
    this._ignore('setSamplingInterval', params);
  }

  /**
   */
  start() {
    this._lastName = 'Profile ' + (++this._lastIdx);
    profiler.startProfiling(this._lastName, true);
  }

  /**
   *
   * @returns {CPUProfile} profile Recorded profile.
   */
  stop() {
    const profile = profiler.stopProfiling(this._lastName);
    return { profile: fixFileReferences(profile) };
  }
}

module.exports = ProfilerAgent;
