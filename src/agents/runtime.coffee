
_ = require 'underscore'
{prepareEvaluation} = require '../lang'
debug = require '../debug-client'

{toJSONValue, wrapperObject, logAndReturn, throwErr, expressionToHandle, handleToExpression, refToObject} = require '../wrap_and_map'

LOOKUP_TIMEOUT = 2500

languageMode = 'js'

module.exports = RuntimeAgent =
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
    console.log "[Runtime.getProperties] Object id: #{objectId}"

    if ref is 'backtrace'
      # debug.request 'scope', { arguments: { number: scope, frameNumber: frame, inlineRefs: true } }, (msg) ->
      debug.request 'scope', { arguments: { number: scope, frameNumber: parseInt(frame), inlineRefs: true } }, (msg) ->
        if msg.success
          refs = {}
          if msg.refs and Array.isArray msg.refs
            msg.refs.forEach (r) ->
              refs[r.handle] = r

          cb null, msg.body.object.properties.map (p) ->
            r = refs[p.value.ref]
            { name: p.name, value: refToObject r }
        else
          console.log '[debug.error] scope: ', msg
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
            obj = msg.body[handle]
            return cb(null, null) unless obj.properties?

            refs = {}
            props = []
            if msg.refs && Array.isArray(msg.refs)
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
