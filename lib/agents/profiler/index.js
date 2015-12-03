'use strict';

const _ = require('lodash');
const profiler = require('v8-profiler');

const setSamplingInterval = require('bindings')('DebugThread').setSamplingInterval;

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
    this._pendingNames = [];
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
    setSamplingInterval(params.interval | 0);
  }

  _generateName() {
    return 'Profile ' + (++this._lastIdx);
  }

  _start(name) {
    if (this._pendingNames.indexOf(name) !== -1) {
      throw new Error(`Can't start two profiles named ${name}`);
    }
    this._pendingNames.push(name);
    profiler.startProfiling(name, true);
  }

  _stop(name) {
    // Remove `name` from the list of pending profiles
    this._pendingNames = this._pendingNames
      .filter(pending => pending !== name);
    const profile = profiler.stopProfiling(name);
    return fixFileReferences(profile);
  }

  /**
   */
  start() {
    this._start(this._generateName(), true);
  }

  /**
   *
   * @returns {CPUProfile} profile Recorded profile.
   */
  stop() {
    const profile = this._stop(this._pendingNames.pop());
    return { profile };
  }
}

const agent = module.exports = ProfilerAgent;

(function setupConsoleInterface() {
  /* eslint no-console:0 */
  console.profile = function profile(optionalName) {
    const name = optionalName || agent._generateName();
    agent._start(name);
    agent.emit('consoleProfileStarted', {
      id: `${name}`,
      location: {},
      title: `${name}`,
    });
  };

  console.profileEnd = function profileEnd(optionalName) {
    const name = optionalName || agent._pendingNames.pop();
    const profile = agent._stop(name);
    agent.emit('consoleProfileFinished', {
      id: `${name}`,
      location: {},
      profile: profile,
      title: `${name}`,
    });
  };
})();
