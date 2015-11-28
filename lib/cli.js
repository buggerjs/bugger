'use strict';

const path = require('path');
const Module = require('module');
const vm = require('vm');

const minimist = require('minimist');
const rc = require('rc');

const startDebug = require('./bugger');

const Debug = vm.runInDebugContext('Debug');

const USAGE = `SYNOPSIS
\tbugger [ -options ] filename [ args ... ]
\tbugger [ --version | -v ]
\tbugger [ --help | -h ]

OPTIONS
\t-v, --version  Print version information
\t-h, --help     Show this help screen
\t-p, --port     The devtools protocol port to use, default: 8058
\t-b, --brk      Pause on the first line of the script`;

const argv = minimist(process.argv.slice(2), {
  boolean: [ 'brk', 'help', 'version' ],
  alias: { 'version': 'v', 'help': 'h', 'port': 'p', 'brk': 'b' },
  stopEarly: true,
});
const config = rc('bugger', {
  port: 8058,
}, argv);
const debugBreak = config.brk;

if (config.version) {
  process.stdout.write(require('../package.json').version + '\n');
  process.exit(0);
} else if (!config._.length || config.help) {
  process.stderr.write(`${USAGE}\n`);
  process.exit(config.help ? 0 : 1);
}

const resolvedArgv = require.resolve(path.resolve(process.cwd(), config._.shift()));
process.argv = [ process.argv[0], resolvedArgv ].concat(config._);

const agents = startDebug(config);
agents.get('Console'); // To make sure we capture console messages
agents.get('Debugger'); // To make sure we capture break events
agents.get('Worker'); // To make sure we capture workers that are created

// Patching this so we can properly break on the first line.
Module.prototype._compile = function _compile(content, filename) {
  /* eslint no-param-reassign:0 */
  const self = this;
  // remove shebang
  content = content.replace(/^\#\!.*/, '');

  function require(request) {
    return self.require(request);
  }

  require.resolve = function resolve(request) {
    return Module._resolveFilename(request, self);
  };

  Object.defineProperty(require, 'paths', { get: function get() {
    throw new Error('require.paths is removed. Use ' +
                    'node_modules folders, or the NODE_PATH ' +
                    'environment variable instead.');
  }});

  require.main = process.mainModule;

  // Enable support to add extra extension types
  require.extensions = Module._extensions;
  require.registerExtension = function registerExtension() {
    throw new Error('require.registerExtension() removed. Use ' +
                    'require.extensions instead.');
  };

  require.cache = Module._cache;

  const dirname = path.dirname(filename);

  // create wrapper function
  const wrapper = Module.wrap(content);

  const compiledWrapper = vm.runInThisContext(wrapper, { filename });
  if (debugBreak && filename === resolvedArgv) {
    // Set breakpoint on module start
    Debug.setBreakPoint(compiledWrapper, 0, 0);
  }
  const args = [self.exports, require, self, filename, dirname];
  return compiledWrapper.apply(self.exports, args);
};

// nextTick to hide ourselves a little better.
process.nextTick(Module.runMain);
