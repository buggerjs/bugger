
{EventEmitter} = require 'events'

timelineInterval = false

commands =
  startScript: ({entryScript, brk}) ->
    {requireScript} = require '../lang'

    # Require time! This may trigger a debug breakpoint, depending on debugBrk
    requireScript entryScript, (brk is true)

  'Timeline.start': ({maxCallStackDepth}) ->
    console.log 'Timeline#start'
    unless timelineInterval
      timelineInterval = setInterval( ->
        console.log 'Time event triggered'
        process.send {
          method: 'Timeline.eventRecorded'
          record:
            type: 'Time'
            usedHeapSize: process.memoryUsage().heapUsed
            startTime: (new Date()).getTime()
        }
      1000)

  'Timeline.stop': ->
    console.log 'Timeline#stop'
    if timelineInterval
      clearInterval timelineInterval

# We are in a child process
unless module.parent?
  # get ourselves into debug mode
  process.kill process.pid, 'SIGUSR1'

  process.on 'message', (message) ->
    if commands[message.method]?
      commands[message.method](message)
    else
      console.error "[bugger] Unknown message from parent: #{message.method}", message

  process.on 'uncaughtException', (error) ->
    process.send {
      method: 'uncaughtException'
      error: {
        name: error.name
        message: error.message
        stack: error.stack
        method: error.method
        meta: error.meta
      }
    }

  process.send { method: 'childReady' }

class EntryScriptWrapper extends EventEmitter
  forkEntryScript: ({entryScript, scriptArgs, brk}, cb) ->
    {spawn, fork} = require 'child_process'
    net = require 'net'

    entryScriptProc = fork module.filename, scriptArgs, { silent: true }
    startupFailedTimeout = setTimeout( ->
      throw new Error 'Process for entry script failed to start'
    1000)

    module.exports.proc = entryScriptProc

    backChannelHandlers =
      childReady: ->
        clearTimeout(startupFailedTimeout) if startupFailedTimeout
        startupFailedTimeout = true

        debugConnection = net.connect 5858, ->
          entryScriptProc.send { method: 'startScript', entryScript, brk }
          cb { entryScriptProc, debugConnection }

      uncaughtException: ({error}) ->
        console.log 'Uncaught exception in child:', error

    entryScriptProc.on 'message', (message) ->
      if backChannelHandlers[message.method]?
        backChannelHandlers[message.method](message)
      else
        module.exports.emit 'message', message

module.exports = new EntryScriptWrapper()
