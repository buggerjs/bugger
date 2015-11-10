'use strict';

const vm = require('vm');

const Bluebird = require('bluebird');
const _ = require('lodash');
const debug = require('debug')('embedded-agents:agents');

const Debug = vm.runInDebugContext('Debug');
const EventNames = [ 'Invalid' ].concat(Object.keys(Debug.DebugEvent));

class Agents {
  constructor(thread) {
    this._thread = thread;
    this._cache = new Map();
    this._paused = false;

    thread.on('message', this._onDevtoolsMessage.bind(this));
    Debug.setListener(this._onDebugEvent.bind(this));
  }

  _pause() {
    debug('_pause');
    this._paused = true;

    const thread = this._thread;
    let message;
    while (this._paused && !!(message = thread.poll())) {
      this._onDevtoolsMessage(message);
    }
    this._paused = false;
  }

  _resume() {
    debug('_resume');
    this._paused = false;
  }

  _onDebugEvent(type, state, event) {
    debug('debugEvent', { type: EventNames[type], state, event });
  }

  _sendJSON(value) {
    const json = JSON.stringify(value);
    this._thread.postMessage(new Buffer(json));
  }

  _onDevtoolsMessage(buffer) {
    const req = JSON.parse('' + buffer);
    const domainMethod = req.method;
    const params = req.params || {};
    const id = req.id;

    const sendResult = result => {
      this._sendJSON({ id, result, error: null });
    };

    const sendError = error => {
      this._sendJSON({ id, result: null, error: {
        message: error.message,
        stack: error.stack,
      }});
    };

    let result, error;
    try {
      result = this.dispatch(domainMethod, params);
    } catch (err) {
      error = err;
    }

    if (error) {
      sendError(error);
    } else if (result && typeof result.then === 'function') {
      result.then(sendResult, sendError);
    } else {
      sendResult(result);
    }
  }

  dispatch(domainMethod, params) {
    const parts = domainMethod.split('.');
    const agent = this.get(parts[0]);
    const method = parts[1];

    return agent[method](params);
  }

  get(domain) {
    if (!this._cache.has(domain)) {
      const Agent = require(`./agents/${_.kebabCase(domain)}`);
      const agent = new Agent();
      try {
        const Probe = require(`./agents/${_.kebabCase(domain)}/probe`);
        agent.ProbeProto = Probe.prototype;
      } catch (err) {
        if (err.code !== 'MODULE_NOT_FOUND') {
          throw err;
        }
        debug('No probe for %s', domain, err);
      }
      this._cache.set(domain, agent);
    }
    return this._cache.get(domain);
  }
}
module.exports = Agents;
