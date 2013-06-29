
{extend} = require 'lodash'

primitiveTypes =
  undefined: true
  boolean: true
  number: true
  string: true

isPrimitiveValue = (body) ->
  body.type && primitiveTypes[body.type]

RemoteObject = ({returnByValue, generatePreview}) -> (refs) ->
  parseBody = (body) ->
    _resolveReffed = (o) ->
      return null unless o?
      o.ref = o.ref.toString() if o.ref?
      o.handle = o.handle.toString() if o.handle?
      if o.ref? and not o.handle?
        extend o, { handle: o.ref }, refs[o.ref]
      else
        o

    _functionName = (fn) ->
      return null unless fn?
      if !!fn.inferredName then fn.inferredName
      else fn.name

    _constructorName = ->
      byCtor = _functionName _resolveReffed body.constructorFunction
      byCtor ? body.text?.replace(/^#<(.*)>$/, '$1')

    _toString = (obj) ->
      obj.className

    _describe = (obj) ->
      # Type is object, get subtype.
      {subtype, className} = obj

      switch subtype
        when 'regexp' then _toString obj
        when 'date' then _toString obj
        when 'array'
          if body.length? then "#{className}[#{body.length}]"
          else className
        else className

    _generateProtoPreview = (obj, preview, propertiesThreshold) ->
      console.log obj, preview, propertiesThreshold

    _generatePreview = (obj) ->
      preview =
        lossless: true
        overflow: false
        properties: []

      propertiesThreshold =
        properties: 5
        indexes: 100

      o = obj
      while o? and o.type != 'undefined'
        _generateProtoPreview o, preview, propertiesThreshold
        o = _resolveReffed o.prototypeObject

      return preview

    _resolveReffed body

    obj =
      type: body.type

    if isPrimitiveValue obj
      if obj.type isnt 'undefined'
        obj.value = body.value

      if obj.type is 'number'
        obj.description = obj.value.toString()
    else if body.type is 'null'
      obj.type = 'object'
      obj.subtype = 'null'
      obj.value = null
    else
      obj.objectId = body.handle
      obj.subtype =
        switch body.className
          when 'Date' then 'date'
          when 'RegExp' then 'regexp'
          when 'Array' then 'array'
      obj.type = 'object' unless obj.type is 'function'
      obj.className = _constructorName()
      obj.description = _describe(obj)
      obj.value = null

      if returnByValue
        obj.value = (body.properties ? []).reduce ((acc, propDescriptor) ->
          {name} = propDescriptor
          propObj = parseBody propDescriptor
          acc[name] = propObj.value
          acc
        ), {}

      if generatePreview and obj.type is 'object'
        obj.preview = _generatePreview()

    obj

ErrorObjectFromMessage = ({returnByValue, generatePreview}) -> (refs) -> (msg) ->
  match = msg.match /^(\w+): (.*)$/
  if match?
    className = match[1]
    message = match[2]
    objectId = "const::#{JSON.stringify { message, type: className }}"
    { type: 'object', description: msg, className, objectId }
  else
    { type: 'string', value: message }

module.exports = {RemoteObject, ErrorObjectFromMessage}
