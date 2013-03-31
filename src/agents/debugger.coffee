
debug = require '../debug-client'

{refToObject} = require '../wrap_and_map'

module.exports = DebuggerAgent =
  enable: (cb) ->
    console.log 'Debbuger#enable'
    cb(null, true)

  disable: (cb) ->
    console.log 'Debbuger#disable'
    cb(null, true)

  setPauseOnExceptions: ({state}, cb) ->
    console.log 'Debugger#setPauseOnExceptions', arguments[0]
    cb(null, true)

  setBreakpointsActive: ({active}, cb) ->
    console.log 'Debugger#setBreakpointsActive', arguments[0]
    cb(null, true)

  removeBreakpoint: ({breakpointId}, cb) ->
    debug.request 'clearbreakpoint', { arguments: { breakpoint: breakpointId } }, (msg) ->
      for id of debug.breakpoints
        if debug.breakpoints[id] is breakpointId
          delete debug.breakpoints[id]
          break
      cb null

  setBreakpointByUrl: ({ lineNumber, url, columnNumber, condition }, cb) ->
    enabled = true; sourceID = debug.sourceUrls[url]
    if bp = debug.breakpoints[sourceID + ':' + lineNumber]
      args = { arguments: { breakpoint: bp.breakpointId, enabled, condition } }
      debug.request 'changebreakpoint', args, (msg) ->
        bp.enabled = enabled
        bp.condition = condition
        cb null, bp.breakpointId, bp.locations
    else
      args = { type: 'scriptId', target: sourceID, line: lineNumber, enabled, condition }
      debug.request 'setbreakpoint', { arguments: args }, (msg) ->
        if msg.success
          b = msg.body
          bp = debug.breakpoints[b.script_id + ':' + b.line] = {
            sourceID: b.script_id
            url: debug.sourceIDs[b.script_id].url
            line: b.line
            breakpointId: b.breakpoint.toString()
            locations: b.actual_locations.map (l) ->
              scriptId: l.script_id.toString()
              lineNumber: l.line # lineNumber is zero-indexed; l.line is zero-indexed
              columnNumber: l.column
            enabled: enabled
            condition: condition
          }

          cb null, bp.breakpointId, bp.locations

  pause: (cb) ->
    console.log 'Debugger#pause'
    debug.request 'suspend', {}, (msg) ->
      debug.emit 'break'

  resume: (cb) ->
    console.log 'Debugger#resume'
    debug.request 'continue', {}, (msg) ->
      cb(null, true)

  stepOver: (cb) ->
    debug.request 'continue', { arguments: {stepaction: 'next'} }, (msg) ->
      cb(null, true)
    # sendEvent('resumedScript')

  stepInto: (cb) ->
    debug.request 'continue', { arguments: {stepaction: 'in'} }, (msg) ->
      cb(null, true)
    # sendEvent('resumedScript')

  stepOutOfFunction: (cb) ->
    debug.request 'continue', { arguments: {stepaction: 'out'} }, (msg) ->
      cb(null, true)
    # sendEvent('resumedScript')

  getScriptSource: ({scriptId}, cb) ->
    args =
      arguments:
        includeSource: true,
        types: 4,
        ids: [scriptId]
    debug.request 'scripts', args, (msg) ->
      cb null, msg.body[0].source

  evaluateOnCallFrame: (options, cb) ->
    {callFrameId, expression, objectGroup, includeCommandLineAPI} = options
    {doNotPauseOnExceptionsAndMuteConsole, returnByValue, generatePreview} = options
    #
    args =
      expression: expression
      disable_break: doNotPauseOnExceptionsAndMuteConsole
      global: true
      maxStringLength: 100000

    if callFrameId?
      args.frame = callFrameId
      args.global = false

    debug.request 'evaluate', { arguments: args }, (result) ->
      if result.success
        resolvedObj = refToObject(result.body)
        if returnByValue and not resolvedObj.value?
          resolvedObj.value = toJSONValue(result.body, result.refs)

        cb null, resolvedObj
      else
        cb result.message
