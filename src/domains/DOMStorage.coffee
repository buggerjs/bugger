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
  DOMStorage.emit_domStorageItemsCleared = (params) ->
    notification = {params, method: 'DOMStorage.domStorageItemsCleared'}
    @emit 'notification', notification

  # @param storageId StorageId 
  # @param key string 
  DOMStorage.emit_domStorageItemRemoved = (params) ->
    notification = {params, method: 'DOMStorage.domStorageItemRemoved'}
    @emit 'notification', notification

  # @param storageId StorageId 
  # @param key string 
  # @param newValue string 
  DOMStorage.emit_domStorageItemAdded = (params) ->
    notification = {params, method: 'DOMStorage.domStorageItemAdded'}
    @emit 'notification', notification

  # @param storageId StorageId 
  # @param key string 
  # @param oldValue string 
  # @param newValue string 
  DOMStorage.emit_domStorageItemUpdated = (params) ->
    notification = {params, method: 'DOMStorage.domStorageItemUpdated'}
    @emit 'notification', notification

  # # Types
  # DOM Storage identifier.
  DOMStorage.StorageId = {"id":"StorageId","type":"object","description":"DOM Storage identifier.","hidden":true,"properties":[{"name":"securityOrigin","type":"string","description":"Security origin for the storage."},{"name":"isLocalStorage","type":"boolean","description":"Whether the storage is local storage (not session storage)."}]}
  # DOM Storage item.
  DOMStorage.Item = {"id":"Item","type":"array","description":"DOM Storage item.","hidden":true,"items":{"type":"string"}}

  return DOMStorage
