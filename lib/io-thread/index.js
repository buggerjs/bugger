/* global thread */
'use strict';

const http = require('http');
const EventEmitter = require('events').EventEmitter;

const WebSocketServer = require('ws').Server;

const threadEvents = new EventEmitter();
thread.onMessage = function onMessage(message) {
  threadEvents.emit('message', message);
};

const server = http.createServer((req, res) => {
  /* eslint no-console: 0 */
  console.error('[Devtools API] %s %s', req.method, req.url);
  res.setHeader('Content-Type', 'application/json');
  res.end('{}');
});

const wss = new WebSocketServer({ server: server });

wss.on('connection', client => {
  function accept(json) {
    thread.postMessage(new Buffer(json));
  }

  function dispatch(message) {
    client.send('' + message);
  }

  function setup() {
    client.on('message', accept);
    threadEvents.on('message', dispatch);
  }

  function cleanup() {
    client.removeListener('message', accept);
    threadEvents.removeListener('message', dispatch);
  }

  setup();
  client.on('close', cleanup);
});

const port = 8058;
server.listen(port, () => {
  const devtoolsUrl =
    'chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:' + port + '/websocket';
  console.error(devtoolsUrl);
});
