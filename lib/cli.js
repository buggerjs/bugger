'use strict';

var parseArgv = require('minimist');
var _ = require('lodash');

var v8Flags = require('./v8-flags');

var v8Defaults = v8Flags.flags.reduce((out, flag) => {
  out[flag.name] = flag.default;
  return out;
}, {});

var argv = parseArgv(process.argv.slice(2), {
  alias: {
    'v': 'version',
    'h': 'help',
  },
  boolean: v8Flags.boolean.concat([
    'version',
    'help',
    'brk',
    'hang',
    'stfu',
  ]),
  default: _.extend({
    brk: true,
    webport: 8058,
    webhost: '127.0.0.1',
    hang: false,
    stfu: true,
  }, v8Defaults),
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
var execArgv = buggerOptions.execArgv = [];
v8Flags.flags.forEach(function(flag) {
  var name = flag.name;
  if (name in argv && argv[name] !== flag.default) {
    if (flag.type === 'bool') {
      var prefix = argv[name] ? '--' : '--no-';
      execArgv.push(prefix + name);
    } else {
      execArgv.push('--' + name + '=' + argv[name]);
    }
  }
});

var script = argv._.shift();
var scriptArgs = argv._;

var bugger = require('./bugger')(buggerOptions);
bugger.on('error', function (err) {
  if (argv.stfu)
    return;
  console.error('[bugger] [error] %s\n%s', err.message, err.stack);
});
bugger.run(script, scriptArgs);
