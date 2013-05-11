# Domain bindings for DOMStorage
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  DOMStorage = new EventEmitter()

  # Enables storage tracking, storage events will now be delivered to the client.
  DOMStorage.enable = ({}, cb) ->
    # Not implemented

  # Disables storage tracking, prevents storage events from being sent to the client.
  DOMStorage.disable = ({}, cb) ->
    # Not implemented

  # @param storageId StorageId 
  # @returns entries Item[] 
  DOMStorage.getDOMStorageItems = ({storageId}, cb) ->
    # Not implemented

  # @param storageId StorageId 
  # @param key string 
  # @param value string 
  DOMStorage.setDOMStorageItem = ({storageId, key, value}, cb) ->
    # Not implemented

  # @param storageId StorageId 
  # @param key string 
  DOMStorage.removeDOMStorageItem = ({storageId, key}, cb) ->
    # Not implemented

  # @param storageId StorageId 
  # @param key string 
  DOMStorage.emit_removeDOMStorageItem = (params) ->
    notification = {params, method: 'DOMStorage.removeDOMStorageItem'}
    @emit 'notification', notification

  # @param storageId StorageId 
  # @param key string 
  DOMStorage.emit_removeDOMStorageItem = (params) ->
    notification = {params, method: 'DOMStorage.removeDOMStorageItem'}
    @emit 'notification', notification

  # @param storageId StorageId 
  # @param key string 
  DOMStorage.emit_removeDOMStorageItem = (params) ->
    notification = {params, method: 'DOMStorage.removeDOMStorageItem'}
    @emit 'notification', notification

  # @param storageId StorageId 
  # @param key string 
  DOMStorage.emit_removeDOMStorageItem = (params) ->
    notification = {params, method: 'DOMStorage.removeDOMStorageItem'}
    @emit 'notification', notification

  # # Types
  # DOM Storage identifier.
  DOMStorage.StorageId = {"id":"StorageId","type":"object","description":"DOM Storage identifier.","hidden":true,"properties":[{"name":"securityOrigin","type":"string","description":"Security origin for the storage."},{"name":"isLocalStorage","type":"boolean","description":"Whether the storage is local storage (not session storage)."}]}
  # DOM Storage item.
  DOMStorage.Item = {"id":"Item","type":"array","description":"DOM Storage item.","hidden":true,"items":{"type":"string"}}

  return DOMStorage
