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

const resolvedArgv = require.resolve(path.resolve(process.cwd(), config._.shift()));
process.argv = [ process.argv[0], resolvedArgv ].concat(config._);

const agents = startDebug();
agents.get('Debugger'); // To make sure we capture break events

const vm = require('vm');
const Debug = vm.runInDebugContext('Debug');

const debugBreak = config.brk;

// Run the file contents in the correct scope or sandbox. Expose
// the correct helper variables (require, module, exports) to
// the file.
// Returns exception, if any.
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

  const compiledWrapper = vm.runInThisContext(wrapper, { filename: filename });
  if (debugBreak && filename === resolvedArgv) {
    // Set breakpoint on module start
    Debug.setBreakPoint(compiledWrapper, 0, 0);
  }
  const args = [self.exports, require, self, filename, dirname];
  return compiledWrapper.apply(self.exports, args);
};

// nextTick to hide ourselves a little better.
process.nextTick(Module.runMain);
