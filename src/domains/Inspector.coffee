# Domain bindings for Inspector
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Inspector = new EventEmitter()

  # Enables inspector domain notifications.
  Inspector.enable = ({}, cb) ->
    # Not implemented

  # Disables inspector domain notifications.
  Inspector.disable = ({}, cb) ->
    # Not implemented

  # @param testCallId integer 
  # @param script string 
  Inspector.emit_evaluateForTestInFrontend = (params) ->
    notification = {params, method: 'Inspector.evaluateForTestInFrontend'}
    @emit 'notification', notification

  # @param object Runtime.RemoteObject 
  # @param hints object 
  Inspector.emit_inspect = (params) ->
    notification = {params, method: 'Inspector.inspect'}
    @emit 'notification', notification

  # Fired when remote debugging connection is about to be terminated. Contains detach reason.
  #
  # @param reason string The reason why connection has been terminated.
  Inspector.emit_detached = (params) ->
    notification = {params, method: 'Inspector.detached'}
    @emit 'notification', notification

  # Fired when debugging target has crashed
  Inspector.emit_targetCrashed = (params) ->
    notification = {params, method: 'Inspector.targetCrashed'}
    @emit 'notification', notification


  return Inspector
