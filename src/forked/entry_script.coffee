
{requireScript} = require '../bugger'
{spawn} = require 'child_process'

net = require 'net'

unless module.parent
  debugBrk = process.argv[2] is 'true'
  entryScript = process.argv[3]

  failedToStart = setTimeout( ->
    console.log 'Waited a second, noone connected to this debugging session.'
    console.log 'Maybe trying again is enough..?'
    throw new Error 'Script failed to start'
  , 1000 )

  # Make sure the parent process attached to our debug port before we continue
  process.once 'SIGUSR2', ->
    # Okay, everything's fine.
    clearTimeout failedToStart
    # Require time! This may trigger a debug breakpoint, depending on debugBrk
    requireScript entryScript, debugBrk

# The exact order of things is important here:
# 1. Create a new child process
# 2. The child process starts listening for debug sessions
# 3. The parent process connects to the debug port of the child process
# 4. The child process hits the first breakpoint
#
# ECONNREFUSED or breakpoints not working are the consequences of some of
# those happen out of order.
module.exports = (entryScript, debugPort, debugBrk, argv_, cb) ->
  args = [
    "--debug=#{debugPort}",
    module.filename,
    debugBrk.toString(),
    entryScript
  ].concat argv_.splice(1)

  entryScriptProc = spawn process.execPath, args
  entryScriptProc.stdout.pipe(process.stdout)
  entryScriptProc.stderr.pipe(process.stderr)

  # Waiting 100 milliseconds is the best compromise between delayed startup
  # and the child not-yet-listening for debug sessions.
  setTimeout( ->
    debugConnection = net.connect debugPort, ->
      # Tell the forked process that we have connected.
      process.kill entryScriptProc.pid, 'SIGUSR2'
      cb { entryScriptProc, debugConnection }
  , 100)
