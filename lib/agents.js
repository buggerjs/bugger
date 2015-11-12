'use strict';

const events = require('events');
const vm = require('vm');

const _ = require('lodash');
const debug = require('debug')('embedded-agents:agents');

const Debug = vm.runInDebugContext('Debug');
const EventNames = [ 'Invalid' ].concat(Object.keys(Debug.DebugEvent))
  .map(name => name[0].toLowerCase() + name.slice(1));

function formatError(error) {
  if (typeof error === 'string') {
    return { message: error };
  }
  return { message: error.message, stack: error.stack };
}

class Agents extends events.EventEmitter {
  constructor(thread) {
    super();

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
    /* eslint no-cond-assign: 0 */
    while (this._paused && !!(message = thread.poll())) {
      this._onDevtoolsMessage(message);
    }
    this._paused = false;
    debug('_pause end');
  }

  _resume() {
    debug('_resume');
    this._paused = false;
  }

  _onDebugEvent(type, state, event) {
    const name = EventNames[type];
    try {
      debug('_onDebugEvent', name);
      this.emit(name, event, state);
    } catch (error) {
      /* eslint no-console: 0 */
      console.error('debugEvent %s', name, error);
    }
  }

  _linkEvents(domain, agent) {
    for (const name of EventNames) {
      const handlerName = `_on${name[0].toUpperCase()}${name.slice(1)}`;
      if (typeof agent[handlerName] === 'function') {
        this.on(name, agent[handlerName].bind(agent));
      }
    }
    agent.on('_event', (eventName, params) => {
      this._sendJSON({ method: `${domain}.${eventName}`, params });
    });
  }

  _sendJSON(value) {
    const json = JSON.stringify(value);
    this._thread.postMessage(new Buffer(json));
    if (value.method === 'Debugger.paused') {
      this._pause();
    } else if (value.method === 'Debugger.resumed') {
      this._resume();
    }
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
      this._sendJSON({ id, result: null, error: formatError(error) });
    };

    let result;
    let error;
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
      this._linkEvents(domain, agent);
      this._cache.set(domain, agent);
    }
    return this._cache.get(domain);
  }
}
module.exports = Agents;
