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

  # @param workerId integer 
  # @param url string 
  # @param inspectorConnected boolean 
  Worker.emit_workerCreated = (params) ->
    notification = {params, method: 'Worker.workerCreated'}
    @emit 'notification', notification

  # @param workerId integer 
  Worker.emit_workerTerminated = (params) ->
    notification = {params, method: 'Worker.workerTerminated'}
    @emit 'notification', notification

  # @param workerId integer 
  # @param message object 
  Worker.emit_dispatchMessageFromWorker = (params) ->
    notification = {params, method: 'Worker.dispatchMessageFromWorker'}
    @emit 'notification', notification

  Worker.emit_disconnectedFromWorker = (params) ->
    notification = {params, method: 'Worker.disconnectedFromWorker'}
    @emit 'notification', notification


  return Worker
