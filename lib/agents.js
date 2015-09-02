'use strict';

const Bluebird = require('bluebird');
const _ = require('lodash');

class Agents {
  constructor() {
    this._cache = new Map();
  }

  dispatch(method, params) {
    const parts = method.split('.');
    const agent = this.get(parts[0]);
    return new Bluebird(function(resolve) {
      resolve(agent[parts[1]](params));
    });
  }

  get(domain) {
    if (!this._cache.has(domain)) {
      const Agent = require(`./agents/${_.kebabCase(domain)}`);
      this._cache.set(domain, new Agent());
    }
    return this._cache.get(domain);
  }
}
module.exports = Agents;
