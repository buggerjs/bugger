
{execFile} = require 'child_process'
path = require 'path'

module.exports = runBugger = (args, cb) ->
  defaultArgs = [ '--stfu' ]
  if args.indexOf('--brk') == -1 && args.indexOf('--no-brk') == -1
    defaultArgs.push '--no-brk'

  args = defaultArgs.concat args
  cwd = path.join __dirname, '..', '..'
  cli = path.join cwd, 'bin', 'bugger.js'
  child = execFile cli, args, {cwd}, cb
  # make sure we don't leak child processes
  process.on 'exit', -> child.kill()
  child
