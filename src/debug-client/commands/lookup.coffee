
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
  lookup = (options) ->
    fn = (objectId, cb) ->
      reqParams = { handles: [objectId], includeSource: false, inlineRefs: true }
      debugClient.sendRequest 'lookup', reqParams, (err, objectMap) ->
        {refs, body, success, message} = response
        if success
          objMap = {}
          mapper = mapValue(options)(refs)
          for handle, ref of body
            objMap[handle] = mapper ref
          cb null, objMap
        else
          cb ErrorObjectFromMessage(options)(refs) message

    return fn

  return lookup
