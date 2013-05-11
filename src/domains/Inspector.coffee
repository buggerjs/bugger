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

  # Disables inspector domain notifications.
  Inspector.emit_disable = (params) ->
    notification = {params, method: 'Inspector.disable'}
    @emit 'notification', notification

  # Disables inspector domain notifications.
  Inspector.emit_disable = (params) ->
    notification = {params, method: 'Inspector.disable'}
    @emit 'notification', notification

  # Disables inspector domain notifications.
  Inspector.emit_disable = (params) ->
    notification = {params, method: 'Inspector.disable'}
    @emit 'notification', notification

  # Disables inspector domain notifications.
  Inspector.emit_disable = (params) ->
    notification = {params, method: 'Inspector.disable'}
    @emit 'notification', notification


  return Inspector
