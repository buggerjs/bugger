'use strict';

const createThread = require('./thread');
const Agents = require('./agents');

function startDebug(config) {
  const thread = createThread(require.resolve('./io-thread'),
    [ '' + config.port, process.argv[1] ]);
  const agents = new Agents(thread);
  return agents;
}
module.exports = startDebug;
