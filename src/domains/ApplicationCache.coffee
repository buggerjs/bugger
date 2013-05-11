# Domain bindings for ApplicationCache
{EventEmitter} = require 'events'

module.exports = (agentContext) ->
  ApplicationCache = new EventEmitter()

  # Returns array of frame identifiers with manifest urls for each frame containing a document associated with some application cache.
  #
  # @returns frameIds FrameWithManifest[] Array of frame identifiers with manifest urls for each frame containing a document associated with some application cache.
  ApplicationCache.getFramesWithManifests = ({}, cb) ->
    # Not implemented

  # Enables application cache domain notifications.
  ApplicationCache.enable = ({}, cb) ->
    # Not implemented

  # Returns manifest URL for document in the given frame.
  #
  # @param frameId Network.FrameId Identifier of the frame containing document whose manifest is retrieved.
  # @returns manifestURL string Manifest URL for document in the given frame.
  ApplicationCache.getManifestForFrame = ({frameId}, cb) ->
    # Not implemented

  # Returns relevant application cache data for the document in given frame.
  #
  # @param frameId Network.FrameId Identifier of the frame containing document whose application cache is retrieved.
  # @returns applicationCache ApplicationCache Relevant application cache data for the document in given frame.
  ApplicationCache.getApplicationCacheForFrame = ({frameId}, cb) ->
    # Not implemented

  # Returns relevant application cache data for the document in given frame.
  #
  # @param frameId Network.FrameId Identifier of the frame containing document whose application cache is retrieved.
  ApplicationCache.emit_getApplicationCacheForFrame = (params) ->
    notification = {params, method: 'ApplicationCache.getApplicationCacheForFrame'}
    @emit 'notification', notification

  # Returns relevant application cache data for the document in given frame.
  #
  # @param frameId Network.FrameId Identifier of the frame containing document whose application cache is retrieved.
  ApplicationCache.emit_getApplicationCacheForFrame = (params) ->
    notification = {params, method: 'ApplicationCache.getApplicationCacheForFrame'}
    @emit 'notification', notification

  # # Types
  # Detailed application cache resource information.
  ApplicationCache.ApplicationCacheResource = {"id":"ApplicationCacheResource","type":"object","description":"Detailed application cache resource information.","properties":[{"name":"url","type":"string","description":"Resource url."},{"name":"size","type":"integer","description":"Resource size."},{"name":"type","type":"string","description":"Resource type."}]}
  # Detailed application cache information.
  ApplicationCache.ApplicationCache = {"id":"ApplicationCache","type":"object","description":"Detailed application cache information.","properties":[{"name":"manifestURL","type":"string","description":"Manifest URL."},{"name":"size","type":"number","description":"Application cache size."},{"name":"creationTime","type":"number","description":"Application cache creation time."},{"name":"updateTime","type":"number","description":"Application cache update time."},{"name":"resources","type":"array","items":{"$ref":"ApplicationCacheResource"},"description":"Application cache resources."}]}
  # Frame identifier - manifest URL pair.
  ApplicationCache.FrameWithManifest = {"id":"FrameWithManifest","type":"object","description":"Frame identifier - manifest URL pair.","properties":[{"name":"frameId","$ref":"Network.FrameId","description":"Frame identifier."},{"name":"manifestURL","type":"string","description":"Manifest URL."},{"name":"status","type":"integer","description":"Application cache status."}]}

  return ApplicationCache
