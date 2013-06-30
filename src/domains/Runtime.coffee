# Domain bindings for Runtime
{EventEmitter} = require 'events'

simpleCounter = -50000

module.exports = ({debugClient}) ->
  Runtime = new EventEmitter()

  objectGroups = {}

  getObjectGroup = (name) ->
    return objectGroups[name] if objectGroups[name]?

    lastObjectId = 0
    objects = {}
    properties = {}

    registerObject = (obj, {expression, global, frame}) ->
      return obj unless obj.objectId?
      objectId = "#{name}::#{lastObjectId++}"
      global ?= !frame?
      objects[objectId] = {expression, global, frame}
      obj.objectId = objectId
      properties[objectId] = obj.properties?.map (property) ->
        propExpr = "(#{expression})[#{JSON.stringify property.name}]"
        {
          name: property.name
          value: registerObject property.value, {global, frame, expression: propExpr}
        }
      obj

    getObjectProperties = (objectId) ->
      properties[objectId]

    releaseAll = ->
      lastObjectId = 0
      objects = {}
      properties = {}

    releaseObject = (objectId) ->
      delete objects[objectId]
      delete properties[objectId]

    resolveObjectId = (objectId) ->
      objects[objectId]

    objectGroups[name] = {registerObject, releaseAll, releaseObject, resolveObjectId, getObjectProperties}

  resolveManagedObjectId = (objectId) ->
    groupName = objectId.split('::')[0]
    getObjectGroup(groupName).resolveObjectId objectId

  getManagedObjectProperties = (objectId) ->
    groupName = objectId.split('::')[0]
    getObjectGroup(groupName).getObjectProperties objectId

  # Parses JavaScript source code for errors.
  #
  # @param source string Source code to parse.
  # @returns result SyntaxErrorType Parse result.
  # @returns message string? Parse error message.
  # @returns range ErrorRange? Range in the source where the error occurred.
  Runtime.parse = ({source}, cb) ->
    # Not implemented

  # Evaluates expression on global object.
  #
  # @param expression string Expression to evaluate.
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @param includeCommandLineAPI boolean? Determines whether Command Line API should be available during the evaluation.
  # @param doNotPauseOnExceptionsAndMuteConsole boolean? Specifies whether evaluation should stop on exceptions and mute console. Overrides setPauseOnException state.
  # @param contextId Runtime.ExecutionContextId? Specifies in which isolated context to perform evaluation. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
  # @param returnByValue boolean? Whether the result is expected to be a JSON object that should be sent by value.
  # @param generatePreview boolean? Whether preview should be generated for the result.
  # @returns result RemoteObject Evaluation result.
  # @returns wasThrown boolean? True if the result was thrown during the evaluation.
  Runtime.evaluate = ({expression, objectGroup, includeCommandLineAPI, doNotPauseOnExceptionsAndMuteConsole, contextId, returnByValue, generatePreview}, cb) ->
    params = { objectGroup, doNotPauseOnExceptionsAndMuteConsole }
    if params.objectGroup
      params.forceObjectId = simpleCounter++

    debugClient.commands.evaluate(params) expression, (err, res) ->
      if err?
        return cb null, result: err, wasThrown: true
      else
        return cb null, result: res

  # Calls function with given declaration on the given object. Object group of the result is inherited from the target object.
  #
  # @param objectId RemoteObjectId Identifier of the object to call function on.
  # @param functionDeclaration string Declaration of the function to call.
  # @param arguments CallArgument[]? Call arguments. All call arguments must belong to the same JavaScript world as the target object.
  # @param doNotPauseOnExceptionsAndMuteConsole boolean? Specifies whether function call should stop on exceptions and mute console. Overrides setPauseOnException state.
  # @param returnByValue boolean? Whether the result is expected to be a JSON object which should be sent by value.
  # @param generatePreview boolean? Whether preview should be generated for the result.
  # @returns result RemoteObject Call result.
  # @returns wasThrown boolean? True if the result was thrown during the evaluation.
  Runtime.callFunctionOn = ({objectId, functionDeclaration, doNotPauseOnExceptionsAndMuteConsole, returnByValue, generatePreview}, cb) ->
    injectObjects = []
    argExpressions = []

    if objectId == '0'
      argExpressions.push 'this'
    else if /^\d+$/.test objectId
      injectObjects.push { name: '$objectCtx', objectId: parseInt(objectId) }
      argExpressions.push '$objectCtx'
    else
      [ objectGroup, forceObjectId ] = objectId.split ':'
      argExpressions.push "root.__bugger__[#{JSON.stringify objectGroup}][#{JSON.stringify forceObjectId}]"

    expression = "(#{functionDeclaration}).call(#{argExpressions.join ', '});"

    params = { doNotPauseOnExceptionsAndMuteConsole, generatePreview, returnByValue, injectObjects }
    debugClient.commands.evaluate(params) expression, (err, res) ->
      if err?
        return cb null, result: err, wasThrown: true
      else
        return cb null, result: res

  # Returns properties of a given object. Object group of the result is inherited from the target object.
  #
  # @param objectId RemoteObjectId Identifier of the object to return properties for.
  # @param ownProperties boolean? If true, returns properties belonging only to the element itself, not to its prototype chain.
  # @returns result PropertyDescriptor[] Object properties.
  # @returns internalProperties InternalPropertyDescriptor[]? Internal object properties.
  Runtime.getProperties = ({objectId, ownProperties}, cb) ->
    if objectId.substr(0, 6) == 'scope:' || /^\d+$/.test objectId
      params = { objectId, ownProperties }
      debugClient.commands.lookup(params) objectId, (err, objectDescriptor) ->
        return cb(err) if err?
        cb null, result: objectDescriptor.properties
    else
      cb new Error "Managed id not supported yet: #{objectId}"

  # Releases remote object with given id.
  #
  # @param objectId RemoteObjectId Identifier of the object to release.
  Runtime.releaseObject = ({objectId}, cb) ->
    if 0 < objectId.indexOf '::'
      [objectGroup] = objectId.split '::'
      getObjectGroup(objectGroup).releaseObject objectId
    cb()

  # Releases all remote objects that belong to a given group.
  #
  # @param objectGroup string Symbolic object group name.
  Runtime.releaseObjectGroup = ({objectGroup}, cb) ->
    getObjectGroup(objectGroup).releaseAll()
    cb()

  # Tells inspected instance(worker or page) that it can run in case it was started paused.
  Runtime.run = ({}, cb) ->
    # Not implemented

  # Enables reporting of execution contexts creation by means of <code>executionContextCreated</code> event. When the reporting gets enabled the event will be sent immediately for each existing execution context.
  Runtime.enable = ({}, cb) ->
    # Not implemented

  # Disables reporting of execution contexts creation.
  Runtime.disable = ({}, cb) ->
    # Not implemented

  # Issued when new execution context is created.
  #
  # @param context ExecutionContextDescription A newly created execution contex.
  Runtime.emit_executionContextCreated = (params) ->
    notification = {params, method: 'Runtime.executionContextCreated'}
    @emit 'notification', notification

  # # Types
  # Unique object identifier.
  Runtime.RemoteObjectId = {"id":"RemoteObjectId","type":"string","description":"Unique object identifier."}
  # Mirror object referencing original JavaScript object.
  Runtime.RemoteObject = {"id":"RemoteObject","type":"object","description":"Mirror object referencing original JavaScript object.","properties":[{"name":"type","type":"string","enum":["object","function","undefined","string","number","boolean"],"description":"Object type."},{"name":"subtype","type":"string","optional":true,"enum":["array","null","node","regexp","date"],"description":"Object subtype hint. Specified for <code>object</code> type values only."},{"name":"className","type":"string","optional":true,"description":"Object class (constructor) name. Specified for <code>object</code> type values only."},{"name":"value","type":"any","optional":true,"description":"Remote object value (in case of primitive values or JSON values if it was requested)."},{"name":"description","type":"string","optional":true,"description":"String representation of the object."},{"name":"objectId","$ref":"RemoteObjectId","optional":true,"description":"Unique object identifier (for non-primitive values)."},{"name":"preview","$ref":"ObjectPreview","optional":true,"description":"Preview containsing abbreviated property values.","hidden":true}]}
  # Object containing abbreviated remote object value.
  Runtime.ObjectPreview = {"id":"ObjectPreview","type":"object","hidden":true,"description":"Object containing abbreviated remote object value.","properties":[{"name":"lossless","type":"boolean","description":"Determines whether preview is lossless (contains all information of the original object)."},{"name":"overflow","type":"boolean","description":"True iff some of the properties of the original did not fit."},{"name":"properties","type":"array","items":{"$ref":"PropertyPreview"},"description":"List of the properties."}]}
  Runtime.PropertyPreview = {"id":"PropertyPreview","type":"object","hidden":true,"properties":[{"name":"name","type":"string","description":"Property name."},{"name":"type","type":"string","enum":["object","function","undefined","string","number","boolean"],"description":"Object type."},{"name":"value","type":"string","optional":true,"description":"User-friendly property value string."},{"name":"valuePreview","$ref":"ObjectPreview","optional":true,"description":"Nested value preview."},{"name":"subtype","type":"string","optional":true,"enum":["array","null","node","regexp","date"],"description":"Object subtype hint. Specified for <code>object</code> type values only."}]}
  # Object property descriptor.
  Runtime.PropertyDescriptor = {"id":"PropertyDescriptor","type":"object","description":"Object property descriptor.","properties":[{"name":"name","type":"string","description":"Property name."},{"name":"value","$ref":"RemoteObject","optional":true,"description":"The value associated with the property."},{"name":"writable","type":"boolean","optional":true,"description":"True if the value associated with the property may be changed (data descriptors only)."},{"name":"get","$ref":"RemoteObject","optional":true,"description":"A function which serves as a getter for the property, or <code>undefined</code> if there is no getter (accessor descriptors only)."},{"name":"set","$ref":"RemoteObject","optional":true,"description":"A function which serves as a setter for the property, or <code>undefined</code> if there is no setter (accessor descriptors only)."},{"name":"configurable","type":"boolean","description":"True if the type of this property descriptor may be changed and if the property may be deleted from the corresponding object."},{"name":"enumerable","type":"boolean","description":"True if this property shows up during enumeration of the properties on the corresponding object."},{"name":"wasThrown","type":"boolean","optional":true,"description":"True if the result was thrown during the evaluation."},{"name":"isOwn","optional":true,"type":"boolean","description":"True if the property is owned for the object.","hidden":true}]}
  # Object internal property descriptor. This property isn't normally visible in JavaScript code.
  Runtime.InternalPropertyDescriptor = {"id":"InternalPropertyDescriptor","type":"object","description":"Object internal property descriptor. This property isn't normally visible in JavaScript code.","properties":[{"name":"name","type":"string","description":"Conventional property name."},{"name":"value","$ref":"RemoteObject","optional":true,"description":"The value associated with the property."}],"hidden":true}
  # Represents function call argument. Either remote object id <code>objectId</code> or primitive <code>value</code> or neither of (for undefined) them should be specified.
  Runtime.CallArgument = {"id":"CallArgument","type":"object","description":"Represents function call argument. Either remote object id <code>objectId</code> or primitive <code>value</code> or neither of (for undefined) them should be specified.","properties":[{"name":"value","type":"any","optional":true,"description":"Primitive value."},{"name":"objectId","$ref":"RemoteObjectId","optional":true,"description":"Remote object handle."}]}
  # Id of an execution context.
  Runtime.ExecutionContextId = {"id":"ExecutionContextId","type":"integer","description":"Id of an execution context."}
  # Description of an isolated world.
  Runtime.ExecutionContextDescription = {"id":"ExecutionContextDescription","type":"object","description":"Description of an isolated world.","properties":[{"name":"id","$ref":"ExecutionContextId","description":"Unique id of the execution context. It can be used to specify in which execution context script evaluation should be performed."},{"name":"isPageContext","type":"boolean","description":"True if this is a context where inpspected web page scripts run. False if it is a content script isolated context.","hidden":true},{"name":"name","type":"string","description":"Human readable name describing given context.","hidden":true},{"name":"frameId","$ref":"Network.FrameId","description":"Id of the owning frame."}]}
  # Syntax error type: "none" for no error, "irrecoverable" for unrecoverable errors, "unterminated-literal" for when there is an unterminated literal, "recoverable" for when the expression is unfinished but valid so far.
  Runtime.SyntaxErrorType = {"id":"SyntaxErrorType","type":"string","enum":["none","irrecoverable","unterminated-literal","recoverable"],"description":"Syntax error type: \"none\" for no error, \"irrecoverable\" for unrecoverable errors, \"unterminated-literal\" for when there is an unterminated literal, \"recoverable\" for when the expression is unfinished but valid so far."}
  # Range of an error in source code.
  Runtime.ErrorRange = {"id":"ErrorRange","type":"object","description":"Range of an error in source code.","properties":[{"name":"startOffset","type":"integer","description":"Start offset of range (inclusive)."},{"name":"endOffset","type":"integer","description":"End offset of range (exclusive)."}]}

  return Runtime
