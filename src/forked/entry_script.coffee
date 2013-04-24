
{EventEmitter} = require 'events'
_ = require 'underscore'

timelineInterval = false

_probeCallbacks = []

commands =
  startScript: ({entryScript, brk, probes}) ->
    {requireScript} = require '../lang'
    {loadProbes} = require '../probes'

    loadProbes(probes ? ['network'])

    # Require time! This may trigger a debug breakpoint, depending on debugBrk
    requireScript entryScript, (brk is true)

  'Timeline.start': ({maxCallStackDepth}) ->
    unless timelineInterval
      timelineInterval = setInterval( ->
        process.send {
          method: 'Timeline.eventRecorded'
          record:
            type: 'Time'
            usedHeapSize: process.memoryUsage().heapUsed
            startTime: (new Date()).getTime()
        }
      1000)

  'Timeline.stop': ->
    if timelineInterval
      clearInterval timelineInterval

# We are in a child process
unless module.parent?
  # get ourselves into debug mode
  process.debugPort = process.env.BUGGER_DEBUG_PORT
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

  # Dummy for keep-alive
  setTimeout (-> ), 5 # dummy

  process.send { method: 'childReady' }

class EntryScriptWrapper extends EventEmitter
  delegate: (method, params, cb) ->
    callbackRef = _probeCallbacks.length
    _probeCallbacks[callbackRef] = cb
    module.exports.proc.send _.extend({method, callbackRef}, params)

  forkEntryScript: ({entryScript, scriptArgs, debugPort, brk}, cb) ->
    {spawn, fork} = require 'child_process'
    net = require 'net'
    networkAgent = require '../agents/network'
    debugClient = require '../debug-client'

    env = _.defaults { BUGGER_DEBUG_PORT: debugPort }, process.env
    entryScriptProc = fork module.filename, scriptArgs, { env, silent: true }
    startupFailedTimeout = setTimeout( ->
      throw new Error 'Process for entry script failed to start'
    1000)

    module.exports.proc = entryScriptProc

    backChannelHandlers =
      childReady: ->
        clearTimeout(startupFailedTimeout) if startupFailedTimeout
        startupFailedTimeout = true

        debugConnection = net.connect debugPort, ->
          debugClient.init connection: debugConnection

          setTimeout (->
            debugClient.request 'continue', {}, ->
              entryScriptProc.send { method: 'startScript', entryScript, brk }
              cb debugClient
          ), 1

      cacheResponseContent: () ->
        # Just plain forwarding
        networkAgent.cacheResponseContent.apply networkAgent, arguments

      refCallback: ({callbackRef, args}) ->
        _probeCallbacks[callbackRef].apply null, args

      uncaughtException: ({error}) ->
        console.log 'Uncaught exception in child:', error

    entryScriptProc.on 'message', (message) ->
      if backChannelHandlers[message.method]?
        backChannelHandlers[message.method](message)
      else
        module.exports.emit 'message', message

module.exports = new EntryScriptWrapper()
