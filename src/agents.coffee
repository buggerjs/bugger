
entryScript = require './forked/entry_script'

agents =
  Timeline:
    start: ({maxCallStackDepth}, cb, channel) ->
      entryScript.proc.send { method: 'Timeline.start' }
      cb null, true

    stop: (cb, channel) ->
      entryScript.proc.send { method: 'Timeline.stop' }
      cb null, true

  Debugger: require './agents/debugger'

  Console: require './agents/console'

  Runtime: require './agents/runtime'

module.exports =
  invoke: (agentName, functionName, args) ->
    agent = agents[agentName]
    handlerFn = agent?[functionName]

    if handlerFn
      handlerFn.apply(agent, args)
    else
      entryScript.delegate "#{agentName}.#{functionName}", args[0], args[1]
