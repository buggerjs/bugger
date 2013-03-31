# # cli.coffee
# 
# Main entry point for the cli application

forkChrome = require './forked/chrome'
{forkEntryScript} = require './forked/entry_script'

debugClient = require './debug-client'
inspectorServer = require './inspector/server'

Module = require 'module'

run = ->
  argv = require './argv'
  {chrome, brk, webhost, webport} = argv
  debugPort = argv['debugport']

  # Make sure node knows about the additional script parsers
  require './lang'

  # Resolve the entry script to a full filename
  entryScriptArg = argv._.shift()
  entryScript =
    try
      Module._resolveFilename entryScriptArg
    catch err
      throw err if entryScriptArg[0] is '/'
      Module._resolveFilename "./#{entryScriptArg}"
  scriptArgs = argv._ # remaining parameters get passed through

  # We'll really try to make the child processes die whenever we die.
  _entryScriptProc = null
  _chromeProc = null

  process.on 'exit', ->
    console.log '[bugger] Cleanup on exit...'
    try _entryScriptProc.kill() if _entryScriptProc?
    try _chromeProc.kill() if _chromeProc?

  process.once 'uncaughtException', (e) ->
    console.log '[bugger] Cleanup on exception...'
    try _entryScriptProc.kill() if _entryScriptProc?
    try _chromeProc.kill() if _chromeProc?
    throw e

  appUrl = argv.getAppUrl()

  if chrome
    # Start chrome with the correct url opened and less UI
    _chromeProc = forkChrome { webhost, webport, appUrl }
    _chromeProc.on 'exit', ->
      console.log '[bugger] Chrome closed, exiting...'
      process.exit 0

  forkEntryScript {entryScript, scriptArgs, brk, debugPort}, ({entryScriptProc, debugConnection}) ->
    _entryScriptProc = entryScriptProc
    _entryScriptProc.on 'exit', ->
      console.log '[bugger] Script finished, exiting...'
      process.exit 0

    # Create a proper debug client from the connection
    debugClient.init { connection: debugConnection }
    inspectorServer.start { webhost, webport, appUrl }

module.exports = {run}
