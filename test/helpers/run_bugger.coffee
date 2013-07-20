
{execFile} = require 'child_process'
path = require 'path'

module.exports = runBugger = (args, cb) ->
  args = [ '--stfu', '--no-brk' ].concat args
  cwd = path.join __dirname, '..', '..'
  cli = path.join cwd, 'bin', 'bugger.js'
  execFile cli, args, {cwd}, cb
