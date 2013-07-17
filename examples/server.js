/**
 * Simple server
 * 
 * Start with:
 * ```bash
 * # Pass port via env variable
 * PORT=5000 bugger examples/server.js
 * 
 * # Pass port as --port / -p
 * bugger --no-brk examples/server.js -- --port=5000
 * bugger --no-brk examples/server.js -- -p 5000
 * 
 * # Pass port as additional param
 * bugger --no-brk examples/server.js 5000
 * 
 * # If you don't pass a port, a random one will be used
 * bugger --no-brk examples/server.js
 * ```
 */
var http = require('http');
var argvParser = require('optimist').usage('server.js [PORT]');

var argv = argvParser.argv;
var port = argv.port;
    port || (port = argv.p);
    port || (port = argv._[0]);
    port || (port = process.env.PORT);
    port || (port = 0);

console.time('[SERVER.JS] Startup');

var httpServer = http.createServer(function(req, res) {
  console.log('[SERVER.JS]', req.method, req.url);
  res.write('OK');
  res.end();
});

httpServer.listen(port, function() {
  var ref = this.address(), port = ref.port, host = ref.address;
  console.log('[SERVER.JS]', 'http://' + host + ':' + port);
  console.timeEnd('[SERVER.JS] Startup');
}).on('error', function(e) {
  console.log(e);
  console.timeEnd('[SERVER.JS] Startup');
});
