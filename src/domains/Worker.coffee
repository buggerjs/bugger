# Domain bindings for Worker
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  Worker = new EventEmitter()

  Worker.enable = ({}, cb) ->
    # Not implemented

  Worker.disable = ({}, cb) ->
    # Not implemented

  # @param workerId integer 
  # @param message object 
  Worker.sendMessageToWorker = ({workerId, message}, cb) ->
    # Not implemented

  # Tells whether browser supports workers inspection.
  #
  # @returns result boolean True if browser has workers support.
  Worker.canInspectWorkers = ({}, cb) ->
    # Not implemented

  # @param workerId integer 
  Worker.connectToWorker = ({workerId}, cb) ->
    # Not implemented

  # @param workerId integer 
  Worker.disconnectFromWorker = ({workerId}, cb) ->
    # Not implemented

  # @param value boolean 
  Worker.setAutoconnectToWorkers = ({value}, cb) ->
    # Not implemented

  # @param value boolean 
  Worker.emit_setAutoconnectToWorkers = (params) ->
    notification = {params, method: 'Worker.setAutoconnectToWorkers'}
    @emit 'notification', notification

  # @param value boolean 
  Worker.emit_setAutoconnectToWorkers = (params) ->
    notification = {params, method: 'Worker.setAutoconnectToWorkers'}
    @emit 'notification', notification

  # @param value boolean 
  Worker.emit_setAutoconnectToWorkers = (params) ->
    notification = {params, method: 'Worker.setAutoconnectToWorkers'}
    @emit 'notification', notification

  # @param value boolean 
  Worker.emit_setAutoconnectToWorkers = (params) ->
    notification = {params, method: 'Worker.setAutoconnectToWorkers'}
    @emit 'notification', notification


  return Worker
