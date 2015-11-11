'use strict';

var http = require('http');
var EventEmitter = require('events').EventEmitter;

var WebSocketServer = require('ws').Server;
var debug = require('debug')('embedded-agents:io-thread');

var threadEvents = new EventEmitter();
thread.onMessage = function onMessage(message) {
  threadEvents.emit('message', message);
};

var server = http.createServer(function(req, res) {
  console.error('[Devtools API] %s %s', req.method, req.url);
  res.setHeader('Content-Type', 'application/json');
  res.end('{}');
});

var wss = new WebSocketServer({
  server: server
});

wss.on('connection', function(client) {
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

var port = 8058;
server.listen(port, function() {
  var devtoolsUrl =
    'chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:' + port + '/websocket';
  console.error(devtoolsUrl);
});
