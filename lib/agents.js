'use strict';

const events = require('events');
const fs = require('fs');
const vm = require('vm');

const _ = require('lodash');
const debug = require('debug')('bugger:agents');

function loadAgentClasses() {
  const byDomain = {};
  for (const kebabDomain of fs.readdirSync(__dirname + '/agents')) {
    if (kebabDomain.indexOf('.') !== -1) continue;
    const camelDomain = _.camelCase(kebabDomain);
    const domain = camelDomain[0].toUpperCase() + camelDomain.slice(1);
    byDomain[domain] = require('./agents/' + kebabDomain);
  }
  return byDomain;
}

const agentClasses = loadAgentClasses();
const knownDomains = Object.keys(agentClasses);

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
  constructor(sendJSON) {
    super();

    this._byDomain = Object.create(null);
    this._sendJSON = sendJSON;

    for (const domain of knownDomains) {
      const AgentClass = agentClasses[domain];
      const agent = new AgentClass();
      this._linkEvents(domain, agent);
      this._byDomain[domain] = agent;
    }
  }

  dispose() {
    this.removeAllListeners();
    for (const domain of knownDomains) {
      this._byDomain[domain].removeAllListeners();
    }
  }

  _onDebugEvent(name, state, event) {
    try {
      debug('_onDebugEvent', name);
      this.emit(name, event, state);
    } catch (error) {
      /* eslint no-console: 0 */
      console.error('debugEvent %s', name, error.stack || error);
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

  _onDevtoolsMessage(req) {
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
    return this._byDomain[domain];
  }
}
module.exports = Agents;
