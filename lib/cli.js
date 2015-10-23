'use strict';

var parseArgv = require('minimist');
var _ = require('lodash');

var argv = parseArgv(process.argv.slice(2), {
  alias: {
    'v': 'version',
    'h': 'help',
  },
  boolean: [
    'version',
    'help',
    'brk',
    'hang',
    'stfu',
  ],
  default: {
    brk: true,
    webport: 8058,
    webhost: '127.0.0.1',
    hang: false,
    stfu: true,
  },
  stopEarly: true,
  string: [
    'webhost',
  ],
});

if (argv.version) {
  version = require('../package.json').version;
  console.log(version);
  process.exit(0);
}

function showHelp(exitCode) {
  console.log('bugger [OPTIONS] FILE_NAME');
  process.exit(exitCode);
}
if (argv.help) {
  showHelp(0);
}
if (!argv._.length) {
  showHelp(1);
}

var buggerOptions = _.pick(argv, 'webport', 'webhost', 'hang', 'stfu', 'language', 'probes');
buggerOptions.debugBreak = !!argv.brk;

var script = argv._.shift();
var scriptArgs = argv._;

var bugger = require('./bugger')(buggerOptions);
bugger.on('error', function (err) {
  if (argv.stfu)
    return;
  console.error('[bugger] [error] %s\n%s', err.message, err.stack);
});
bugger.run(script, scriptArgs);
