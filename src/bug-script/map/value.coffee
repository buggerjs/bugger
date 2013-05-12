
###
Runtime.RemoteObject = {"id":"RemoteObject","type":"object","description":"Mirror object referencing original JavaScript object.","properties":[
  {"name":"type","type":"string","enum":["object","function","undefined","string","number","boolean"],"description":"Object type."},
  {"name":"subtype","type":"string","optional":true,"enum":["array","null","node","regexp","date"],"description":"Object subtype hint. Specified for <code>object</code> type values only."},
  {"name":"className","type":"string","optional":true,"description":"Object class (constructor) name. Specified for <code>object</code> type values only."},
  {"name":"value","type":"any","optional":true,"description":"Remote object value (in case of primitive values or JSON values if it was requested)."},
  {"name":"description","type":"string","optional":true,"description":"String representation of the object."},
  {"name":"objectId","$ref":"RemoteObjectId","optional":true,"description":"Unique object identifier (for non-primitive values)."},
  {"name":"preview","$ref":"ObjectPreview","optional":true,"description":"Preview containsing abbreviated property values.","hidden":true}]}

Runtime.PropertyPreview = {"id":"PropertyPreview","type":"object","hidden":true,"properties":[
  {"name":"name","type":"string","description":"Property name."},
  {"name":"type","type":"string","enum":["object","function","undefined","string","number","boolean"],"description":"Object type."},
  {"name":"value","type":"string","optional":true,"description":"User-friendly property value string."},
  {"name":"valuePreview","$ref":"ObjectPreview","optional":true,"description":"Nested value preview."},
  {"name":"subtype","type":"string","optional":true,"enum":["array","null","node","regexp","date"],"description":"Object subtype hint. Specified for <code>object</code> type values only."}]}

# Object property descriptor.
Runtime.PropertyDescriptor = {"id":"PropertyDescriptor","type":"object","description":"Object property descriptor.","properties":[
  {"name":"name","type":"string","description":"Property name."},
  {"name":"value","$ref":"RemoteObject","optional":true,"description":"The value associated with the property."},
  {"name":"writable","type":"boolean","optional":true,"description":"True if the value associated with the property may be changed (data descriptors only)."},
  {"name":"get","$ref":"RemoteObject","optional":true,"description":"A function which serves as a getter for the property, or <code>undefined</code> if there is no getter (accessor descriptors only)."},
  {"name":"set","$ref":"RemoteObject","optional":true,"description":"A function which serves as a setter for the property, or <code>undefined</code> if there is no setter (accessor descriptors only)."},
  {"name":"configurable","type":"boolean","description":"True if the type of this property descriptor may be changed and if the property may be deleted from the corresponding object."},
  {"name":"enumerable","type":"boolean","description":"True if this property shows up during enumeration of the properties on the corresponding object."},
  {"name":"wasThrown","type":"boolean","optional":true,"description":"True if the result was thrown during the evaluation."},
  {"name":"isOwn","optional":true,"type":"boolean","description":"True if the property is owned for the object.","hidden":true}]}
###

stringify = require 'json-stringify-safe'

resolveSelfRef = (refs, body) ->
  if body.ref?
    refs[body.ref] ? body
  else
    body

isPrimitive = (obj) ->
  obj.type in [ 'number', 'string', 'boolean', 'undefined', 'null' ]

module.exports = (refs) ->
  mapValue = (_body, depth = 0) ->
    body = resolveSelfRef refs, _body
    body.handle ?= body.ref

    return refs["value:#{body.handle}"] if refs["value:#{body.handle}"]?

    objectDefaults = (obj) ->
      obj.objectId = body.handle.toString()
      obj.className = body.className
      obj.description = (body.text ? '').replace /^#<(.*)>$/, '$1'
      obj.preview = body.text

      if obj.description == 'Array'
        obj.subtype = 'array'
        for property in body.properties
          if property.name is 'length' and property.value?
            obj.description += "[#{property.value.value}]"

      if body.properties? and depth == 0
        obj.properties = body.properties.map (property) ->
          unless property.value
            property.value = refs[property.ref] ? property

          name: property.name?.toString()
          value: mapValue(property.value, ++depth)

      obj

    if body.type in ['null', 'undefined']
      {
        type: body.type
      }
    else if body.type in [ 'number', 'string', 'boolean' ]
      {
        type: body.type
        value: body.value
        preview: body.value
      }
    else if body.type is 'function'
      {
        type: 'function'
        preview: body.text
        className: body.className
        description: if !!body.name then body.name else body.inferredName
      }
    else if body.type is 'regexp'
      ###
      { "handle":191
      , "type":"regexp"
      , "className":"RegExp"
      , "constructorFunction":{"ref":143,"type":"function","name":"RegExp","inferredName":""}
      , "protoObject":{"ref":449,"type":"regexp","value":"/(?:)/"}
      , "prototypeObject":{"ref":3,"type":"undefined"}
      , "properties":
        [ { "name":"lastIndex","value":{"ref":189,"type":"number","value":0}}
        , {"name":"source","value":{"ref":569,"type":"string","value":"^[\\/]*"}}
        , {"name":"ignoreCase","value":{"ref":215,"type":"boolean","value":false}}
        , {"name":"multiline","value":{"ref":215,"type":"boolean","value":false}}
        , {"name":"global","value":{"ref":215,"type":"boolean","value":false}}]
      ,"text":"/^[\\/]*/" }
      ###
      objectDefaults {
        type: 'object'
        subtype: 'regexp'
      }
    else if body.type is 'object'
      objectDefaults {
        type: 'object'
      }
    else
      { type: 'object', objectId: body.handle }
