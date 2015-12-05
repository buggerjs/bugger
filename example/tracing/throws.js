'use strict';

const fs = require('fs');
const path = require('path');

const tEnd = Date.now() + 150; // we want this to take 250ms

while (Date.now() < tEnd) {
  fs.readFileSync(path.join(__dirname, '../../package.json'), 'utf8');
}

fs.readFileSync(path.join(__dirname, '../../not-a-thing.json'), 'utf8');
