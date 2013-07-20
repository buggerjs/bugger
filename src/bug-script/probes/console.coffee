
ConsoleProbe = ->
  root.__bugger__ ?= {}
  root.__bugger__['console'] ?= {}

  logCounter = 0

  __old_log = console.log
  console.log = ->
    # process.send
    #   method: 'Profiler.emit_setRecordingProfile'
    #   isProfiling: true

    if arguments.length < 1
      __old_log.apply console, arguments
    else if arguments.length == 1 && typeof arguments[0] == 'string'
      __old_log.apply console, arguments
    else
      parameters = []
      logId = "_log#{++logCounter}"
      objectIdPrefix = "console:#{logId}"
      subId = 0
      for arg in arguments
        param = { type: typeof arg }
        if not arg? or param.type in [ 'string', 'number', 'boolean' ]
          param.value = arg
          param.type = 'null' if arg == null
        else
          param.description = arg.constructor.name
          param.subtype =
            switch arg.constructor.name
              when 'Date' then 'date'
              when 'RegExp' then 'regexp'
              when 'Array'
                param.description = "Array[#{arg.length}]"
                'array'

          if Buffer.isBuffer arg
            param.description = "Buffer[#{arg.length}]"

          ++subId
          param.objectId = "#{objectIdPrefix}:#{JSON.stringify [subId]}"
          logStore = root.__bugger__['console'][logId] ?= {}
          logStore[subId] = arg

        parameters.push param

      process.send
        method: 'Console.emit_messageAdded'
        message:
          level: 'log'
          parameters: parameters

load = (scriptContext, safe = false) ->
  return if safe

  agents =
    Console: ConsoleProbe()

  process.on 'message', (message) ->
    if message.type == 'forward_req'
      {command, seq} = message
      [domain, method] = command.split '.'
      return unless domain in [ 'Console' ]

      [domain, method] = message.command.split '.'
      agents[domain][method] message.params, (err, data) ->
        response = { command, request_seq: seq, type: 'forward_res' }
        if err?
          response.error = message: err.message, code: err.code, type: err.type
        else
          response.data = data
        
        process.send response

module.exports = {load}
