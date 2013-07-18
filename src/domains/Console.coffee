# Domain bindings for Console
{EventEmitter} = require 'events'

{defaults} = require 'lodash'

module.exports = ({debugClient, forked}) ->
  Console = new EventEmitter()

  ConsoleMessage = (attrs) ->
    defaults attrs, {
      source: 'javascript'
      level: 'log'
    }

  processStdOutData = (data) ->
    rawText = data.toString()
    parameters = []
    parsedText = rawText.replace /\x1B\[(\d+)m/g, (_, code) ->
      color = switch code
        when '0', '39' then 'black'
        when '31' then 'maroon'
        when '32' then 'green'
        when '33' then 'olive'
        when '34' then 'navy'
        when '35' then 'purple'
        when '36' then 'teal'
        when '37' then 'silver'
      parameters.push type: 'string', value: "color: #{color}"
      '%c'

    Console.emit_messageAdded message: ConsoleMessage {
      parameters: [ { type: 'string', value: parsedText } ].concat parameters
    }

  processStdErrData = (data) ->
    Console.emit_messageAdded message: ConsoleMessage {
      text: data.toString()
      level: 'error'
    }

  # Enables console domain, sends the messages collected so far to the client by means of the <code>messageAdded</code> notification.
  Console.enable = ({}, cb) ->
    forked.stdout.on 'data', processStdOutData
    forked.stderr.on 'data', processStdErrData
    cb()

  # Disables console domain, prevents further console messages from being reported to the client.
  Console.disable = ({}, cb) ->
    forked.stdout.removeListener 'data', processStdOutData
    forked.stderr.removeListener 'data', processStdErrData
    cb()

  # Clears console messages collected in the browser.
  Console.clearMessages = ({}, cb) ->
    # Not implemented

  # Toggles monitoring of XMLHttpRequest. If <code>true</code>, console will receive messages upon each XHR issued.
  #
  # @param enabled boolean Monitoring enabled state.
  Console.setMonitoringXHREnabled = ({enabled}, cb) ->
    # Not implemented

  # Enables console to refer to the node with given id via $x (see Command Line API for more details $x functions).
  #
  # @param nodeId DOM.NodeId DOM node id to be accessible by means of $x command line API.
  Console.addInspectedNode = ({nodeId}, cb) ->
    # Not implemented

  # @param heapObjectId integer 
  Console.addInspectedHeapObject = ({heapObjectId}, cb) ->
    # Not implemented

  # Issued when new console message is added.
  #
  # @param message ConsoleMessage Console message that has been added.
  Console.emit_messageAdded = (params) ->
    notification = {params, method: 'Console.messageAdded'}
    @emit 'notification', notification

  # Issued when subsequent message(s) are equal to the previous one(s).
  #
  # @param count integer New repeat count value.
  Console.emit_messageRepeatCountUpdated = (params) ->
    notification = {params, method: 'Console.messageRepeatCountUpdated'}
    @emit 'notification', notification

  # Issued when console is cleared. This happens either upon <code>clearMessages</code> command or after page navigation.
  Console.emit_messagesCleared = (params) ->
    notification = {params, method: 'Console.messagesCleared'}
    @emit 'notification', notification

  # # Types
  # Console message.
  Console.ConsoleMessage = {"id":"ConsoleMessage","type":"object","description":"Console message.","properties":[{"name":"source","type":"string","enum":["xml","javascript","network","console-api","storage","appcache","rendering","css","security","other"],"description":"Message source."},{"name":"level","type":"string","enum":["log","warning","error","debug"],"description":"Message severity."},{"name":"text","type":"string","description":"Message text."},{"name":"type","type":"string","optional":true,"enum":["log","dir","dirxml","table","trace","clear","startGroup","startGroupCollapsed","endGroup","assert","timing","profile","profileEnd"],"description":"Console message type."},{"name":"url","type":"string","optional":true,"description":"URL of the message origin."},{"name":"line","type":"integer","optional":true,"description":"Line number in the resource that generated this message."},{"name":"column","type":"integer","optional":true,"description":"Column number on the line in the resource that generated this message."},{"name":"repeatCount","type":"integer","optional":true,"description":"Repeat count for repeated messages."},{"name":"parameters","type":"array","items":{"$ref":"Runtime.RemoteObject"},"optional":true,"description":"Message parameters in case of the formatted message."},{"name":"stackTrace","$ref":"StackTrace","optional":true,"description":"JavaScript stack trace for assertions and error messages."},{"name":"networkRequestId","$ref":"Network.RequestId","optional":true,"description":"Identifier of the network request associated with this message."}]}
  # Stack entry for console errors and assertions.
  Console.CallFrame = {"id":"CallFrame","type":"object","description":"Stack entry for console errors and assertions.","properties":[{"name":"functionName","type":"string","description":"JavaScript function name."},{"name":"url","type":"string","description":"JavaScript script name or url."},{"name":"lineNumber","type":"integer","description":"JavaScript script line number."},{"name":"columnNumber","type":"integer","description":"JavaScript script column number."}]}
  # Call frames for assertions or error messages.
  Console.StackTrace = {"id":"StackTrace","type":"array","items":{"$ref":"CallFrame"},"description":"Call frames for assertions or error messages."}

  return Console
