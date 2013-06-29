
{omit, extend} = require 'lodash'

{RemoteObject, ErrorObjectFromMessage} = require '../remote-object'

assertObjectGroup = (objectGroup) ->
  cmd  = "root.__bugger__ || (root.__bugger__ = {});"
  cmd += "root.__bugger__[#{JSON.stringify objectGroup}]"
  cmd += " || (root.__bugger__[#{JSON.stringify objectGroup}] = {});"

safeInObjectGroup = (objectGroup, objectId, expr) ->
  cmd  = assertObjectGroup objectGroup
  cmd += "root.__bugger__[#{JSON.stringify objectGroup}][#{JSON.stringify objectId}] = (#{expr});"

module.exports = (debugClient) ->
  evaluate = (options) ->
    fn = (expression, cb) ->
      forcedId = null
      if options.objectGroup and options.forceObjectId
        {objectGroup, forceObjectId} = options
        expression = safeInObjectGroup objectGroup, forceObjectId, expression
        forcedId = "#{objectGroup}:#{forceObjectId}"

      reqParams = extend {expression}, {
        disable_break: !!options.doNotPauseOnExceptionsAndMuteConsole
        global: !options.callFrameId
        frame: options.callFrameId
      }

      if options.returnByValue
        reqParams.inline_refs = true

      if options.injectObjects
        reqParams.additional_context = options.injectObjects.map (injectObject) ->
          { name: injectObject.name, handle: parseInt(injectObject.objectId, 10) }

      debugClient.sendRequest 'evaluate', reqParams, (err, response) ->
        {refs, body, success, message} = response
        if success
          remoteObject = RemoteObject(options)(refs) body
          if forcedId? and remoteObject.objectId?
            remoteObject.objectId = forcedId
          cb null, remoteObject
        else
          cb ErrorObjectFromMessage(options)(refs) message

    fn.withOptions = (overrides) ->
      evaluate extend({}, options, overrides)

    fn.onCallFrame = (callFrameId) ->
      fn.withOptions {callFrameId}

    fn.saveInObjectGroup = (objectGroup, objectId) ->
      fn.withOptions {objectGroup, forceObjectId: objectId}

    return fn

  return evaluate
