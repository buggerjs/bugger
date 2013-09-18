'use strict';

var fs = require('fs'),
    crypto = require('crypto'),
    createReadStream = fs.createReadStream,
    createHash = crypto.createHash;

var filename = module.filename;

function hashHash(hash) {
  createHash('md5').update(hash).digest('hex');
};

function hashYourSelf() {
  var inStream = createReadStream(filename);
  var hash = createHash('sha1');

  inStream.on('data', function(chunk) {
    hash.update(chunk);
  }).on('end', function() {
    var hexDigest = hash.digest('hex');
    process.stderr.write('...')
    for (var i = 0; i < 10000; ++i) {
      hashHash(hexDigest);
    }
    console.error(' ok.');
  });
};

var intervalHandle = null;
global.beBusy = function() {
  if (intervalHandle != null) {
    notBeBusy();
  }

  intervalHandle = setInterval(hashYourSelf, 1000);
};

global.notBeBusy = function() {
  if (intervalHandle) {
    clearInterval(intervalHandle);
    intervalHandle = null;
  }
};
