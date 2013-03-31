
_ = require 'underscore'

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

logAndReturn = (expr) ->
  console.log expr
  expr

wrapperObject = (type, description, hasChildren, frame, scope, ref, subtype) ->
  type: type
  subtype: subtype
  description: description
  hasChildren: type in ['function', 'object']
  objectId: if type in ['function', 'object'] then "#{frame}:#{scope}:#{ref}" else null

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

module.exports = {toJSONValue, wrapperObject, logAndReturn, throwErr, expressionToHandle, handleToExpression, refToObject}
