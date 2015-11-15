'use strict';

const createThread = require('./thread');
const Agents = require('./agents');

function startDebug() {
  const thread = createThread(require.resolve('./io-thread'));
  const agents = new Agents(thread);
  return agents;
}
module.exports = startDebug;
