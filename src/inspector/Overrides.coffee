
# debugger always enabled
WebInspector.settings.debuggerEnabled.set true
# source maps always enabled
WebInspector.settings.sourceMapsEnabled.set true
window.dumpInspectorProtocolMessages = false

preloadMessageBuffer = []
InspectorFrontendHost.sendMessageToBackend = (message) ->
  preloadMessageBuffer.push message

InspectorFrontendHost.loaded = ->
  InspectorFrontendAPI.dispatchQueryParameters()
  WebInspector._doLoadedDoneWithCapabilities()
