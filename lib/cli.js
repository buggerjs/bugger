'use strict';

const path = require('path');
const Module = require('module');

const minimist = require('minimist');
const rc = require('rc');

const startDebug = require('./embedded-agents');

const argv = minimist(process.argv.slice(2), {
  boolean: [ 'brk' ],
  stopEarly: true,
});
const config = rc('bugger', {
  port: 8058,
}, argv);

if (!config._.length) {
  process.stderr.write(`Usage:
  bugger [ <bugger options> ] <filename> [ <program arguments> ]\n`);
  process.exit(1);
}

const filename = path.resolve(process.cwd(), config._.shift());
process.argv = [ process.argv[0], filename ].concat(config._);

startDebug();

// This will read the filename from process.argv
Module.runMain();
