
{omit, extend} = require 'lodash'

{RemoteObject, ErrorObjectFromMessage} = require '../remote-object'

assertObjectGroup = (objectGroup) ->
  cmd  = "root.__bugger__ || (root.__bugger__ = {});"
  cmd += "root.__bugger__[#{JSON.stringify objectGroup}]"
  cmd += " || (root.__bugger__[#{JSON.stringify objectGroup}] = {});"

safeInObjectGroup = (objectGroup, objectId, expr) ->
  cmd  = assertObjectGroup objectGroup
  cmd += "root.__bugger__[#{JSON.stringify objectGroup}][#{JSON.stringify objectId}] = (#{expr});"

getObjectProperties = (refMap) -> (rawObj) ->
  seenProps = {}
  rawObj.properties.map( (prop) ->
    value = RemoteObject({})(refMap) (prop.value ? prop)
    { name: prop.name?.toString(), value }
  ).filter (prop) ->
    return false unless prop.name?
    return false if seenProps[prop.name]
    seenProps[prop.name] = true

module.exports = (debugClient) ->
  lookup = (options) ->
    fromNativeId = (objectId, cb) ->
      reqParams = { handles: [parseInt objectId, 10], includeSource: false }
      debugClient.sendRequest 'lookup', reqParams, (err, response) ->
        {refMap, body, success, message} = response
        if success
          rawObj = body[objectId.toString()]
          objDescription =
            properties: getObjectProperties(refMap) rawObj
            # properties: rawObj.properties.map (prop) ->
            #   value = RemoteObject({})(refMap) prop
            #   { name: prop.name?.toString(), value }
          cb null, objDescription
        else
          cb ErrorObjectFromMessage(options)(refMap) message

    fromScope = (objectId, cb) ->
      [ _, frameNumber, scopeNumber ] = objectId.split ':'
      reqParams =
        number: parseInt(scopeNumber, 10)
        frameNumber: parseInt(frameNumber, 10)
        inlineRefs: true

      debugClient.sendRequest 'scope', reqParams, (err, response) ->
        {refMap, body, success, message} = response
        if success
          objDescription =
            properties: getObjectProperties(refMap) body.object
            # properties: body.object.properties.map (prop) ->
            #   value = RemoteObject({})(refMap) prop.value
            #   { name: prop.name?.toString(), value }
          cb null, objDescription
        else
          cb ErrorObjectFromMessage(options)(refMap) message

    fn = (objectId, cb) ->
      if objectId?.substr(0, 6) == 'scope:'
        fromScope objectId, cb
      else if objectId?
        fromNativeId objectId, cb
      else
        cb null, []

    return fn

  return lookup
