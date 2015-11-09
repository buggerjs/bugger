'use strict';

var createServer = require('http').createServer;
var EventEmitter = require('events').EventEmitter;

var _ = require('lodash');
var WebSocketServer = require('ws').Server;

var withAgents = require('./with-agents');

function getDefaults() {
  return {
    debugBreak: true,
    webport: 8058,
    webhost: '127.0.0.1',
    hang: true,
    stfu: false,
    language: null,
    propes: null,
  };
}

function getTitle(meta) {
  var path = require('path');
  var relPath = path.relative(meta.cwd, meta.mainModule);
  var args = meta.argv.map(function(arg) { return JSON.stringify(arg); });
  return [ relPath ].concat(args).join(' ');
}

function createBugger(options) {
  options = _.extend(getDefaults(), options);

  function run(filename, args) {
    return withAgents(filename, args, options).then(setupServer);
  }

  function setupServer(agents) {
    var meta = agents.getMeta();

    var port = options.webport || 8058;
    var pageId = '961C1EB7-A0DA-2F42-F6D4-76B453E70DB5';
    // var devtoolsBase = 'chrome-devtools://devtools/bundled/inspector.html';
    var devtoolsBase = 'https://chrome-devtools-frontend.appspot.com/serve_rev/@202665/inspector.html';
    var ws = '127.0.0.1:' + port + '/devtools/page/' + pageId;

    var page = {
      description: '',
      devtoolsFrontendUrl: devtoolsBase + '?ws=' + ws,
      faviconUrl: 'https://nodejs.org/favicon.ico',
      id: pageId,
      title: getTitle(meta),
      type: 'page',
      url: 'http://127.0.0.1:' + meta.debugPort,
      webSocketDebuggerUrl: 'ws://' + ws
    };

    var httpServer = createServer(function(req, res) {
      if (req.url === '/json/version') {
        return res.end(JSON.stringify({
          Browser: 'Node/' + process.version.substr(1), // 'Chrome/37.0.2062.124',
          'Protocol-Version': '1.1',
          'User-Agent': 'Node/' + process.version + ' v8' + process.versions.v8,
          'WebKit-Version': '537.36 (@181352)'
        }));
      } else if (req.url === '/json') {
        return res.end(JSON.stringify([ page ]));
      } else if (req.url === '/json/activate/' + pageId) {
        return res.end('"Target activated"');
      }
      console.log('[bugger-agents] %s %s', req.method, req.url);
      res.end('ok');
    });

    var webSocket = new WebSocketServer({
      server: httpServer,
      maxReceivedFrameSize: 0x100000, // 1MB
      autoAcceptConnections: true
    });

    webSocket.on('connection', function(client) {
      agents.connectToWebsocketClient(client);
    });

    httpServer.listen(port, function() {
      var devtoolsUrl =
        'chrome-devtools://devtools/bundled/inspector.html?ws=127.0.0.1:' + port + '/websocket';
      console.log(devtoolsUrl);
    });
  }

  var bugger = new EventEmitter();
  bugger.run = run;
  return bugger;
}
module.exports = createBugger;
