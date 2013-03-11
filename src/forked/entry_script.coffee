
MESSAGE_CHILD_READY = 'CHILD_READY'
MESSAGE_CHILD_EXCEPTION = 'CHILD_EXCEPTION'

runningScriptName = null

commands =
  startScript: ({entryScript, debugBrk}) ->
    {requireScript} = require '../bugger'
    runningScriptName = entryScript

    # Require time! This may trigger a debug breakpoint, depending on debugBrk
    requireScript entryScript, (debugBrk is true)

  restartScript: ->
    Module = require 'module'
    Module._cache = {}
    Module._sourceMaps = {}

    {requireScript} = require '../bugger'
    # Always break on first line when we are restarting
    requireScript runningScriptName, true

# We are in a child process
unless module.parent?
  # get ourselves into debug mode
  process.kill process.pid, 'SIGUSR1'

  process.on 'message', (message) ->
    if commands[message.code]?
      commands[message.code](message)
    else
      console.error "[bugger] Unknown message from parent: #{message.code}", message

  process.on 'uncaughtException', (error) ->
    process.send {
      code: 'uncaughtException'
      error: {
        name: error.name
        message: error.message
        stack: error.stack
        code: error.code
        meta: error.meta
      }
    }

  process.send { code: 'childReady' }

module.exports =
  forkEntryScript: (entryScript, debugPort, debugBrk, argv_, cb) ->
    {spawn, fork} = require 'child_process'
    net = require 'net'

    entryScriptProc = fork module.filename, argv_.splice(1), silent: false
    startupFailedTimeout = setTimeout( ->
      throw new Error 'Process for entry script failed to start'
    1000)

    backChannelHandlers =
      childReady: ->
        clearTimeout(startupFailedTimeout) if startupFailedTimeout
        startupFailedTimeout = true

        debugConnection = net.connect debugPort, ->
          entryScriptProc.send { code: 'startScript', entryScript, debugBrk }
          cb { entryScriptProc, debugConnection }

      uncaughtException: ({error}) ->
        console.log 'Uncaught exception in child:', error

    entryScriptProc.on 'message', (message) ->
      if backChannelHandlers[message.code]?
        backChannelHandlers[message.code](message)
      else
        console.log "[bugger] Unknown message from child: #{message.code}", message
