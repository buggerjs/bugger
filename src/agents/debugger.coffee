
debug = require '../debug-client'

{toJSONValue, refToObject, expressionToHandle, throwErr} = require '../wrap_and_map'

module.exports = DebuggerAgent =
  enable: (cb) ->
    cb(null, true)

  disable: (cb) ->
    cb(null, true)

  setPauseOnExceptions: ({state}, cb) ->
    # TODO
    cb(null, true)

  setBreakpointsActive: ({active}, cb) ->
    # TODO
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
    debug.request 'suspend', {}, (msg) ->
      debug.emit 'break'

  resume: (cb) ->
    debug.request 'continue', {}, (msg) ->
      debug.emit 'resumed'
      cb(null, true)

  stepOver: (cb) ->
    debug.request 'continue', { arguments: {stepaction: 'next'} }, (msg) ->
      debug.emit 'resumed'
      cb(null, true)

  stepInto: (cb) ->
    debug.request 'continue', { arguments: {stepaction: 'in'} }, (msg) ->
      debug.emit 'resumed'
      cb(null, true)

  stepOutOfFunction: (cb) ->
    debug.request 'continue', { arguments: {stepaction: 'out'} }, (msg) ->
      debug.emit 'resumed'
      cb(null, true)

  getScriptSource: ({scriptId}, cb) ->
    args =
      arguments:
        includeSource: true,
        types: 4,
        ids: [scriptId]
    debug.request 'scripts', args, (msg) ->
      cb null, msg.body[0].source

  setScriptSource: ({scriptId, scriptSource, preview}, cb) ->
    args =
      script_id: scriptId
      preview_only: preview
      new_source: scriptSource

    debug.request 'changelive', { arguments: args }, (msg) ->
      if msg.success
        # TODO: is this the proper response?
        cb null, null
      else
        cb msg.message

  getFunctionDetails: ({objectId}, cb) ->
    # response: cb(error, response = { location = { scriptId, lineNumber, columnNumber }, name, inferredName, displayName })

  evaluateOnCallFrame: (options, cb) ->
    {callFrameId, expression, objectGroup, includeCommandLineAPI} = options
    {doNotPauseOnExceptionsAndMuteConsole, returnByValue, generatePreview} = options
    #
    args =
      expression: expression
      disable_break: doNotPauseOnExceptionsAndMuteConsole
      global: false
      maxStringLength: 100000

    if callFrameId?
      args.frame = callFrameId

    debug.request 'evaluate', { arguments: args }, (result) ->
      if result.success
        result.body.handle = expressionToHandle expression
        resolvedObj = refToObject(result.body, callFrameId ? 0)
        if returnByValue and not resolvedObj.value?
          resolvedObj.value = toJSONValue(result.body, result.refs)

        cb null, resolvedObj
      else
        throwErr cb, (result.message + JSON.stringify(args))
