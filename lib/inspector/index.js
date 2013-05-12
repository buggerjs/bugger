// Generated by CoffeeScript 2.0.0-beta5
var createClient, createServer, EventEmitter, inspector, webSocket;
createServer = require('http').createServer;
EventEmitter = require('events').EventEmitter;
webSocket = require('websocket');
createClient = require('./client');
module.exports = function () {
  var httpServer, inspector, websocket;
  inspector = new EventEmitter;
  inspector.clients = {};
  httpServer = inspector.httpServer = createServer(function (req, res) {
    res.write(server.DEFAULT_URL + '\n');
    return res.end();
  });
  websocket = inspector.websocket = new webSocket.server({
    httpServer: httpServer,
    autoAcceptConnections: true
  });
  websocket.on('connect', function (socket) {
    var client;
    client = createClient(socket);
    client.on('error', function (err) {
      return inspector.emit('error', err);
    });
    client.on('request', function (request) {
      return inspector.emit('request', request);
    });
    client.on('close', function () {
      delete inspector.clients[client.id];
      return inspector.emit('disconnect', client);
    });
    inspector.clients[client.id] = client;
    return inspector.emit('join', client);
  });
  inspector.dispatchEvent = function (notification) {
    var client, clientId;
    if (null != notification.params)
      notification.params;
    else
      notification.params = {};
    for (clientId in inspector.clients) {
      client = inspector.clients[clientId];
      client.dispatchEvent(notification);
    }
    return null;
  };
  httpServer.on('listening', function () {
    var address, cache$, port, query;
    cache$ = this.address();
    address = cache$.address;
    port = cache$.port;
    query = 'ws=' + address + ':' + port + '/websocket';
    this.DEFAULT_URL = 'chrome://devtools/devtools.html?' + query;
    return inspector.DEFAULT_URL = this.DEFAULT_URL;
  });
  inspector.listen = function () {
    return httpServer.listen.apply(httpServer, [].slice.call(arguments).concat());
  };
  return inspector;
};
if (!module.parent) {
  inspector = module.exports();
  inspector.listen(8058, function () {
    return console.log('Open Devtools:\n' + this.DEFAULT_URL);
  });
}