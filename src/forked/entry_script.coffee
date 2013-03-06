
{requireScript} = require '../bugger'
{spawn} = require 'child_process'

net = require 'net'

unless module.parent
  debugBrk = process.argv[2] is 'true'
  debugPort = process.argv[3]
  entryScript = process.argv[4]

  # Make sure the debugger is available before we continue
  conn = net.connect debugPort, ->
    conn.end()
    # Require time!
    requireScript entryScript, debugBrk

module.exports = (entryScript, debugPort, debugBrk, argv_) ->
  args = [
    "--debug=#{debugPort}",
    module.filename,
    debugBrk.toString(),
    debugPort,
    entryScript
  ].concat argv_.splice(1)

  entryScriptProc = spawn process.execPath, args
  entryScriptProc.stdout.pipe(process.stdout)
  entryScriptProc.stderr.pipe(process.stderr)
  entryScriptProc
