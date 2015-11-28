'use strict';

const vm = require('vm');

const debug = require('debug')('bugger:bugger');
const _ = require('lodash');

const createThread = require('./thread');
const Agents = require('./agents');

const Debug = vm.runInDebugContext('Debug');
const EventNames = [ 'Invalid' ].concat(Object.keys(Debug.DebugEvent))
  .map(name => name[0].toLowerCase() + name.slice(1));

function startDebug(config) {
  const agentsByConnection = {};
  const thread = createThread(require.resolve('./io-thread'),
    [ '' + config.port, process.argv[1] ]);
  let isPaused = null;

  function resumeExecution(json) {
    debug('_resume');
    isPaused = null;

    // We need to dispatch this to all clients.
    _.each(agentsByConnection, (agent, connectionId) => {
      thread.postMessage(new Buffer(connectionId + ':' + json));
    });
  }

  function setupAgents(connectionId) {
    const prefix = connectionId + ':';

    function sendJSON(value) {
      const json = JSON.stringify(value);
      if (value.method === 'Debugger.resumed') {
        resumeExecution(json);
        return;
      }
      thread.postMessage(new Buffer(prefix + json));
    }

    const agents = new Agents(sendJSON);
    agentsByConnection[connectionId] = agents;

    if (isPaused) {
      agents._onDebugEvent(isPaused.name, isPaused.state, isPaused.event);
    }
  }

  function removeAgents(connectionId) {
    const agents = agentsByConnection[connectionId];
    if (agents) {
      agents.dispose();
    }
    delete agentsByConnection[connectionId];
  }

  function onDevtoolsMessage(messageBuffer) {
    const message = '' + messageBuffer;
    const sepIdx = message.indexOf(':');
    if (sepIdx === -1) {
      debug('Dropping invalid message', message);
      return;
    }
    const connectionId = message.slice(0, sepIdx);
    const data = JSON.parse(message.slice(sepIdx + 1));

    if (data === true) {
      debug('Setting up new connection');
      setupAgents(connectionId);
      return;
    }

    const agents = agentsByConnection[connectionId];
    if (!agents) {
      debug('Dropping message to invalid connection id', connectionId, data);
      return;
    }
    if (data === false) {
      debug('Unregister connection');
      removeAgents(connectionId);
      return;
    }
    agents._onDevtoolsMessage(data);
  }

  function pauseAndPoll(meta) {
    debug('_pause');
    isPaused = meta;

    let message;
    /* eslint no-cond-assign: 0 */
    while (isPaused && !!(message = thread.poll())) {
      onDevtoolsMessage(message);
    }
    isPaused = null;
    debug('_pause end');
  }

  function onDebugEvent(type, state, event) {
    const name = EventNames[type];
    _.each(agentsByConnection, agent => {
      agent._onDebugEvent(name, state, event);
    });

    if (name === 'break' || name === 'exception') {
      pauseAndPoll({ name, state, event });
    }
  }

  Debug.setListener(onDebugEvent);

  thread.on('message', onDevtoolsMessage);
}
module.exports = startDebug;
