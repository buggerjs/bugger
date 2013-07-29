
// the callback param is optional
require('http')
.get('http://localhost:8058')
.on('response', function(res) {
  console.log('ok');
  process.exit(0);
});
