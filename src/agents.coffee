
debug = require './debug-client'
_ = require 'underscore'
{prepareEvaluation} = require './lang'

LOOKUP_TIMEOUT = 2500

breakpoints = {}

languageMode = 'coffee'

throwErr = (cb, msg) ->
  cb null, { type: 'string', value: msg }, true

lastHandle = 0
knownExpressions = {}
knownExpressionsRev = {}

expressionToHandle = (expression) ->
  unless knownExpressions[expression]
    knownExpressions[expression] = ++lastHandle
    knownExpressionsRev[lastHandle.toString()] = expression
  "_#{knownExpressions[expression]}"

handleToExpression = (handle) ->
  knownExpressionsRev[handle.substr(1)]

refToObject = (ref) ->
  desc = ''
  name = null
  subtype = null
  kids = if ref.properties then ref.properties.length else false

  switch ref.type
    when 'object'
      name = /#<(\w+)>/.exec ref.text
      if name?.length > 1
        desc = name[1]
        if desc is 'Array'
          subtype = 'array'
          desc += '[' + (ref.properties.length - 1) + ']'
        else if desc is 'Buffer'
          desc += '[' + (ref.properties.length - 4) + ']'
      else
        desc = ref.className ? 'Object'
    when 'function'
      desc = ref.text ? 'function()'
    else
      desc = ref.text ? ''

  desc = desc.substring(0, 100) + '\u2026' if desc.length > 100
  
  wrapperObject ref.type, desc, kids, 0, 0, ref.handle, subtype

wrapperObject = (type, description, hasChildren, frame, scope, ref, subtype) ->
  type: type
  description: description
  hasChildren: hasChildren
  subtype: subtype
  objectId: "#{frame}:#{scope}:#{ref}"

toJSONValue = (objInfo, refs) ->
  refMap = {}
  refs.forEach (ref) ->
    refMap[ref.handle] = ref

  switch objInfo.type
    when 'object'
      constructorFunction = refMap[objInfo.constructorFunction.ref]
      prototypeObject = refMap[objInfo.prototypeObject.ref]
      protoObject = refMap[objInfo.protoObject.ref]

      properties = {}
      objInfo.properties.forEach (prop) ->
        propObjInfo = _.defaults { handle: "#{objInfo.handle}.#{prop.name}" }, refMap[prop.ref]
        properties[prop.name] = toJSONValue(propObjInfo, refs)

      properties
    when 'boolean' then objInfo.value
    else
      console.log 'Unknown type: ', objInfo.type
      console.log objInfo
      null

###
testJSON = {}
  obj: { "handle":0,"type":"object","className":"Object","constructorFunction":{"ref":1},"protoObject":{"ref":2},"prototypeObject":{"ref":3},"properties":[{"name":"EvalError","ref":1},{"name":"Int16Array","ref":1},{"name":"setTimeout","ref":1},{"name":"URIError","ref":1},{"name":"isFinite","ref":1},{"name":"Infinity","ref":1},{"name":"Buffer","ref":1},{"name":"clearTimeout","ref":1},{"name":"console","ref":1},{"name":"DataView","ref":1},{"name":"Int8Array","ref":1},{"name":"toLocaleString","ref":1},{"name":"Uint16Array","ref":1},{"name":"Math","ref":1},{"name":"Int32Array","ref":1},{"name":"Uint8Array","ref":1},{"name":"unescape","ref":1},{"name":"__lookupGetter__","ref":1},{"name":"cache$1","ref":1},{"name":"RegExp","ref":1},{"name":"Function","ref":1},{"name":"encodeURI","ref":1},{"name":"root","ref":1},{"name":"encodeURIComponent","ref":1},{"name":"constructor","ref":1},{"name":"parseInt","ref":1},{"name":"isPrototypeOf","ref":1},{"name":"Boolean","ref":1},{"name":"process","ref":1},{"name":"toString","ref":1},{"name":"parseFloat","ref":1},{"name":"Float32Array","ref":1},{"name":"Array","ref":1},{"name":"setInterval","ref":1},{"name":"escape","ref":1},{"name":"RangeError","ref":1},{"name":"isNaN","ref":1},{"name":"__lookupSetter__","ref":1},{"name":"decodeURIComponent","ref":1},{"name":"valueOf","ref":1},{"name":"decodeURI","ref":1},{"name":"propertyIsEnumerable","ref":1},{"name":"__defineGetter__","ref":1},{"name":"__defineSetter__","ref":1},{"name":"ArrayBuffer","ref":1},{"name":"global","ref":1},{"name":"Error","ref":1},{"name":"String","ref":1},{"name":"Float64Array","ref":1},{"name":"Object","ref":1},{"name":"hasOwnProperty","ref":1},{"name":"NaN","ref":1},{"name":"GLOBAL","ref":1},{"name":"eval","ref":1},{"name":"Uint32Array","ref":1},{"name":"JSON","ref":1},{"name":"Number","ref":1},{"name":"cache$","ref":1},{"name":"TypeError","ref":1},{"name":"ReferenceError","ref":1},{"name":"Date","ref":1},{"name":"Uint8ClampedArray","ref":1},{"name":"clearInterval","ref":1},{"name":"SyntaxError","ref":1},{"name":"undefined","ref":1}],"text":"#<Object>"}
  refs:[{"handle":1,"type":"boolean","value":true,"text":"true"},{"handle":2,"type":"object","className":"Object","constructorFunction":{"ref":4},"protoObject":{"ref":5},"prototypeObject":{"ref":3},"properties":[{"name":"propertyIsEnumerable","attributes":2,"propertyType":2,"ref":6},{"name":"__defineSetter__","attributes":2,"propertyType":2,"ref":7},{"name":"__lookupGetter__","attributes":2,"propertyType":2,"ref":8},{"name":"__lookupSetter__","attributes":2,"propertyType":2,"ref":9},{"name":"__defineGetter__","attributes":2,"propertyType":2,"ref":10},{"name":"toString","attributes":2,"propertyType":2,"ref":11},{"name":"constructor","attributes":2,"propertyType":2,"ref":4},{"name":"valueOf","attributes":2,"propertyType":2,"ref":12},{"name":"toLocaleString","attributes":2,"propertyType":2,"ref":13},{"name":"isPrototypeOf","attributes":2,"propertyType":2,"ref":14},{"name":"hasOwnProperty","attributes":2,"propertyType":2,"ref":15}],"text":"#<Object>"},{"handle":3,"type":"undefined","text":"undefined"}]}

toJSONValue testJSON.obj, testJSON.refs
###

timelineInterval = false

agents =
  Timeline:
    start: ({maxCallStackDepth}, cb, channel) ->
      console.log 'Timeline#start'
      unless timelineInterval
        timelineInterval = setInterval( ->
          console.log 'Time event triggered'
          channel.pushTimelineEvent 'UpdateMemoryUsage',
            usedHeapSize: Math.floor(Math.random() * 10000)
            startTime: (new Date()).getTime()
        1000)
      cb null, true

    stop: (cb, channel) ->
      console.log 'Timeline#stop'
      if timelineInterval
        clearInterval timelineInterval
      cb null, true

  Debugger:
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
        for id of breakpoints
          if breakpoints[id] is breakpointId
            delete breakpoints[id]
            break
        cb null

    setBreakpointByUrl: ({ lineNumber, url, columnNumber, condition }, cb) ->
      console.log 'setBreakpointByUrl', arguments
      enabled = true; sourceID = debug.sourceUrls[url]
      if bp = breakpoints[sourceID + ':' + lineNumber]
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
            bp = breakpoints[b.script_id + ':' + b.line] = {
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

  Console:
    enable: (cb) ->
      console.log 'Console#enable'
      cb(null, true)

  Runtime:
    evaluate: (options, cb, channel) ->
      {expression, objectGroup, includeCommandLineAPI, doNotPauseOnExceptions, returnByValue} = options

      commandMode = /^:(\w+)$/
      if m = (expression.match commandMode)
        cmd = m[1]
        if cmd in ['js', 'coffee']
          languageMode = cmd
          return channel.console("Switched input language to #{cmd}", 'info')
        else
          return channel.console("Unknown command: #{m[1]}", 'error')

      try
        expression = prepareEvaluation languageMode, expression
      catch parseError
        console.log expression, parseError
        return throwErr cb, parseError.toString()

      args =
        expression: expression
        disable_break: doNotPauseOnExceptions
        global: true
        maxStringLength: 100000

      console.log args

      debug.request 'evaluate', { arguments: args }, (result) ->
        if result.success
          # we need to return object ids that can be referenced by callFunctionOn
          result.body.handle = expressionToHandle expression
          resolvedObj = refToObject(result.body)
          if returnByValue and not resolvedObj.value?
            resolvedObj.value = toJSONValue(result.body, result.refs)

          console.log "Runtime.evaluate #{expression}"
          cb null, resolvedObj
        else
          console.log result
          throwErr cb, result.message
          cb null, result.message, true # was thrown

    callFunctionOn: (options, cb) ->
      {objectId, functionDeclaration, returnByValue} = options
      args = options.arguments
      [frame, scope, ref] = objectId.split ':'
      console.log 'Call on ', objectId, "returnByValue", returnByValue
      expression = "(#{functionDeclaration}).apply(#{handleToExpression ref}, #{JSON.stringify(args)});"
      disable_break = true
      additional_context = [] # [ { name: 'obj', handle: parseInt(ref) } ]
      debug.request 'evaluate', { arguments: { expression, disable_break, additional_context, global: true } }, (result) ->
        if result.success
          resolvedObj = refToObject(result.body)
          if returnByValue and not resolvedObj.value?
            resolvedObj.value = toJSONValue(result.body, result.refs)

          cb null, resolvedObj
        else
          cb result.message

    getProperties: ({objectId, ownProperties}, cb) ->
      [frame, scope, ref] = objectId.split ':'

      if ref is 'backtrace'
        debug.request 'scope', { arguments: { number: scope, frameNumber: frame, inlineRefs: true } }, (msg) ->
          if msg.success
            refs = {}
            if msg.refs and Array.isArray msg.refs
              msg.refs.forEach (r) ->
                refs[r.handle] = r

            cb null, msg.body.object.properties.map (p) ->
              r = refs[p.value.ref]
              { name: p.name, value: refToObject r }
      else
        # if ref is numeric, do a lookup. otherwise: evaluate
        handle = parseInt ref, 10
        if isNaN(handle)
          getOwnProperties = () ->
            props = {}
            for name in Object.getOwnPropertyNames this
              props[name] = this[name]
            props

          functionDeclaration = getOwnProperties.toString()

          expression = "(#{functionDeclaration}).apply(#{handleToExpression ref}, []);"
          disable_break = true
          debug.request 'evaluate', { arguments: { expression, disable_break, global: true } }, (result) ->
            if result.success
              refMap = {}
              result.refs.forEach (refDesc) -> refMap[refDesc.handle] = refDesc

              props = result.body.properties.map (pDesc) ->
                propObj = _.defaults { handle: "#{ref}[#{JSON.stringify pDesc.name}]" }, refMap[pDesc.ref]
                { name: pDesc.name, value: refToObject(propObj) }

              console.log props
              # resolvedObj = refToObject(result.body)
              # if returnByValue and not resolvedObj.value?
              #   resolvedObj.value = toJSONValue(result.body, result.refs)

              cb null, props
            else
              console.log result
              cb result.message
        else
          timeout = setTimeout( ->
            cb null, [{ name: 'sorry', value: wrapperObject( 'string', 'lookup timed out', false, 0, 0, 0) }]
            seq = 0
          LOOKUP_TIMEOUT)
          handles = [ handle ]
          debug.request 'lookup', { arguments: { handles, includeSource: false } }, (msg) ->
            clearTimeout(timeout)
            # TODO break out commonality with above
            if msg.success
              refs = {}
              props = []
              if msg.refs && Array.isArray(msg.refs)
                obj = msg.body[handle]
                objProps = obj.properties
                proto = obj.protoObject
                refs[r.handle] = r for r in msg.refs

                props = objProps.map (p) ->
                  r = refs[p.ref]
                  { name: String(p.name), value: refToObject(r) }

                if proto
                  props.push
                    name: '__proto__',
                    value: refToObject refs[proto.ref]
              cb(null, props)
            else
              console.log '[error] Runtime#getProperties', msg

module.exports =
  invoke: (agentName, functionName, args) ->
    agent = agents[agentName]
    handlerFn = agent[functionName]

    handlerFn.apply(agent, args)
