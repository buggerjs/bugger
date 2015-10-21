'use strict';

const Bluebird = require('bluebird');
const _ = require('lodash');
const debug = require('debug')('embedded-agents:agents');

class Agents {
  constructor() {
    this._cache = new Map();
  }

  dispatch(domainMethod, params) {
    const parts = domainMethod.split('.');
    const agent = this.get(parts[0]);
    const method = parts[1];

    return new Bluebird(function(resolve, reject) {
      if (agent.ProbeProto && agent.ProbeProto[method]) {
        debug('Forwarding to agent', domainMethod);
        // embeddedAgents.callProbeMethod(domainMethod, params, resolve, reject);
      } else {
        resolve(agent[method](params));
      }
    });
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
