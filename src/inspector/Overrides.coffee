
# debugger always enabled
WebInspector.settings.debuggerEnabled.set true
window.dumpInspectorProtocolMessages = true

WebInspector.inspectedPageURL = location.origin

preloadMessageBuffer = []
InspectorFrontendHost.sendMessageToBackend = (message) ->
  console.log 'Buffered', message
  preloadMessageBuffer.push message

InspectorFrontendHost.loaded = ->
  InspectorFrontendAPI.dispatchQueryParameters()
  WebInspector._doLoadedDoneWithCapabilities()

#       for message in preloadMessageBuffer
#         ws.send message
#       preloadMessageBuffer.length = 0

# Wire up websocket to talk to backend
# window.WebInspector.loaded = ->
#     InspectorBackend.loadFromJSONIfNeeded "../Inspector.json"
#     WebInspector.dockController = new WebInspector.DockController()

#     if WebInspector.WorkerManager.isDedicatedWorkerFrontend()
#       # Do not create socket for the worker front-end.
#       return WebInspector.doLoadedDone()

#     ws = WebInspector.socket = io.connect "http://#{window.location.host}/", reconnect: false

#     ws.on 'message', (message) ->
#       if message
#         InspectorBackend.dispatch(message)

#     ws.on('error', (error) -> console.error(error) )

#     ws.on 'connect', ->
#       for message in preloadMessageBuffer
#         ws.send message
#       preloadMessageBuffer.length = 0

#       InspectorFrontendHost.sendMessageToBackend = ws.send.bind(ws)
#       WebInspector.doLoadedDone()

#     # In case of loading as a web page with no bindings / harness, kick off initialization manually.
#     if InspectorFrontendHost.isStub
#       InspectorFrontendAPI.dispatchQueryParameters()
#       WebInspector._doLoadedDoneWithCapabilities()

# window.InspectorFrontendHost.hiddenPanels = ->
#   "elements,resources,timeline,network,audits,profiles"
