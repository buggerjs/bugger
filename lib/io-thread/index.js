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
  client.on('message', function(json) {
    thread.postMessage(new Buffer(json));
  });

  function dispatch(message) {
    client.send('' + message);
  }

  threadEvents.on('message', dispatch);
});

var port = 8058;
server.listen(port, function() {
  var devtoolsUrl =
    'chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:' + port + '/websocket';
  console.error(devtoolsUrl);
});
