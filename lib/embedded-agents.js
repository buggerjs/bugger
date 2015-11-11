'use strict';

const createThread = require('./thread');
const Agents = require('./agents');

function startDebug(mainModule) {
  const thread = createThread(require.resolve('./io-thread'));
  const agents = new Agents(thread);

  require(mainModule);
  return agents;
}
module.exports = startDebug;
