var http = require('http');

var httpServer = http.createServer(function(req, res) {
  res.write('OK');
  res.end();
});

httpServer.listen(0, function() {
  console.log(this.address());
}).on('error', function(e) {
  console.log(e);
});
