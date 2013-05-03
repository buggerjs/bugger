
class InspectorBackendStub
  constructor: ->
    @_lastCallbackId = 1
    @_pendingResponsesCount = 0
    @_callbacks = {}
    @_domainDispatchers = {}
    @_eventArgs = {}

    @agent 'Debugger', (a) ->
      a.ignore 'causesRecompilation'
      a.ignore 'supportsSeparateScriptCompilationAndExecution'
      a.ignore 'canSetScriptSource'
      a.ignore 'setOverlayMessage'
      a.delegate 'getFunctionDetails', { objectId: { optional: false, type: 'string' } }
      a.delegate 'setScriptSource', { scriptId: { optional: false, type: 'string' }, scriptSource: { optional: false, type: 'string'}, preview: { optional: true , type: 'boolean' } }
      a.delegate 'getScriptSource', { scriptId: { optional: false, type: 'string' } }

    @agent 'HeapProfiler', (a) ->
      a.ignore 'hasHeapProfiler'

    @agent 'Timeline', (a) ->
      a.ignore 'supportsFrameInstrumentation'
      a.ignore 'canMonitorMainThread'
      a.ignore 'setIncludeDomCounters'
      a.delegate 'start', { maxCallStackDepth: { optional: true , type: "number" } }
      a.delegate 'stop'

      a.event 'started'
      a.event 'stopped'
      a.event 'eventRecorded', [ 'record' ]

    @agent 'Page', (a) ->
      a.ignore 'enable'
      a.ignore 'canShowDebugBorders'
      a.ignore 'canShowFPSCounter'
      a.ignore 'canContinuouslyPaint'
      a.ignore 'canOverrideDeviceMetrics'
      a.ignore 'canOverrideGeolocation'
      a.ignore 'canOverrideDeviceOrientation'
      a.ignore 'setTouchEmulationEnabled'
      a.ignore 'getScriptExecutionStatus'
      a.delegate 'getResourceTree'
      a.ignore 'addScriptToEvaluateOnLoad', {scriptSource: { optional: false, type: 'string' } }
      a.ignore 'removeAllScriptsToEvaluateOnLoad'
      a.ignore 'reload', { ignoreCache: { optional: true, type: 'boolean' } }
      a.ignore 'open', { url: { optional: false, type: 'string' }, newWindow: { optional: true , type: 'boolean' } }
      a.ignore 'getCookies'
      a.ignore 'deleteCookie', { cookieName: { optional: false, type: 'string' }, domain: { optional: false, type: 'string' } }
      a.ignore 'getResourceContent', { frameId: { optional: false, type: 'string' }, url: { optional: false, type: 'string' } }
      a.ignore 'searchInResources', { text: { optional: false, type: 'string' }, 'caseSensitive': { optional: true , type: 'boolean' }, isRegex: { optional: true , type: 'boolean' } }

    @agent 'CSS', (a) ->
      a.ignore 'enable'

    @agent 'Inspector', (a) ->
      a.ignore 'enable'

    @agent 'Network', (a) ->
      a.ignore 'canClearBrowserCache'
      a.ignore 'canClearBrowserCookies'
      a.delegate 'getResponseBody', { requestId: { optional: false, type: 'string' } }
      a.event 'responseReceived', ['requestId', 'frameId', 'loaderId', 'timestamp', 'type', 'response']
      a.event 'dataReceived', ["requestId","timestamp","dataLength","encodedDataLength"]
      a.event 'loadingFinished', ["requestId","timestamp"]
      a.event 'loadingFailed', ["requestId","timestamp","errorText","canceled"]

    @agent 'Worker', (a) ->
      a.ignore 'enable'

    @agent 'Console', (a) ->
      a.delegate 'enable'
      a.delegate 'disable'
      a.delegate 'clearMessages'
      a.ignore 'setMonitoringXHREnabled', { nodeId: { optional: false, type: 'boolean' } }
      a.delegate 'addInspectedNode', { nodeId: { optional: false, type: 'number' } }

    @agent 'Runtime', (a) ->
      a.ignore 'enable'
      a.ignore 'disable'

    @agent 'ApplicationCache', (a) ->
      a.ignore 'enable'
      a.ignore 'disable'
      a.ignore 'getFramesWithManifests'

    @_registerDelegate('{"method": "Runtime.evaluate", "params": {"expression": {"optional": false, "type": "string"},"objectGroup": {"optional": true , "type": "string"},"includeCommandLineAPI": {"optional": true , "type": "boolean"},"doNotPauseOnExceptions": {"optional": true , "type": "boolean"},"frameId": {"optional": true , "type": "string"},"returnByValue": {"optional": true , "type": "boolean"}}, "id": 0}')
    @_registerDelegate('{"method": "Runtime.callFunctionOn", "params": {"objectId": {"optional": false, "type": "string"},"functionDeclaration": {"optional": false, "type": "string"},"arguments": {"optional": true , "type": "object"},"returnByValue": {"optional": true , "type": "boolean"}}, "id": 0}')
    @_registerDelegate('{"method": "Runtime.getProperties", "params": {"objectId": {"optional": false, "type": "string"},"ownProperties": {"optional": true , "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "Runtime.releaseObject", "params": {"objectId": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "Runtime.releaseObjectGroup", "params": {"objectGroup": {"optional": false, "type": "string"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.enable", "id": 0}')
    @_registerDelegate('{"method": "Debugger.disable", "id": 0}')
    @_registerDelegate('{"method": "Debugger.setBreakpointsActive", "params": {"active": {"optional": false, "type": "boolean"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.setBreakpointByUrl", "params": {"lineNumber": {"optional": false, "type": "number"},"url": {"optional": true , "type": "string"},"urlRegex": {"optional": true , "type": "string"},"columnNumber": {"optional": true , "type": "number"},"condition": {"optional": true , "type": "string"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.setBreakpoint", "params": {"location": {"optional": false, "type": "object"},"condition": {"optional": true , "type": "string"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.removeBreakpoint", "params": {"breakpointId": {"optional": false, "type": "string"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.continueToLocation", "params": {"location": {"optional": false, "type": "object"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.stepOver", "id": 0}')
    @_registerDelegate('{"method": "Debugger.stepInto", "id": 0}')
    @_registerDelegate('{"method": "Debugger.stepOut", "id": 0}')
    @_registerDelegate('{"method": "Debugger.pause", "id": 0}')
    @_registerDelegate('{"method": "Debugger.resume", "id": 0}')
    @_registerDelegate('{"method": "Debugger.setPauseOnExceptions", "params": {"state": {"optional": false, "type": "string"}}, "id": 0}')
    @_registerDelegate('{"method": "Debugger.evaluateOnCallFrame", "params": {"callFrameId": {"optional": true, "type": "string"},"expression": {"optional": false, "type": "string"},"objectGroup": {"optional": true , "type": "string"},"includeCommandLineAPI": {"optional": true , "type": "boolean"}, "doNotPauseOnExceptionsAndMuteConsole": {"optional":true,"type":"boolean"},"returnByValue": {"optional": true , "type": "boolean"},"generatePreview": {"optional": true , "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "Profiler.enable", "id": 0}')
    @_ignore('{"method": "Profiler.disable", "id": 0}')
    @_ignore('{"method": "Profiler.isEnabled", "id": 0}')
    @_ignore('{"method": "Profiler.start", "id": 0}')
    @_ignore('{"method": "Profiler.stop", "id": 0}')
    @_ignore('{"method": "Profiler.getProfileHeaders", "id": 0}')
    @_ignore('{"method": "Profiler.getProfile", "params": {"type": {"optional": false, "type": "string"},"uid": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "Profiler.removeProfile", "params": {"type": {"optional": false, "type": "string"},"uid": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "Profiler.clearProfiles", "id": 0}')
    @_ignore('{"method": "Profiler.takeHeapSnapshot", "id": 0}')
    @_ignore('{"method": "Profiler.collectGarbage", "id": 0}')
    @_ignore('{"method": "Profiler.causesRecompilation", "id": 0}')
    @_ignore('{"method": "Profiler.isSampling", "id": 0}')
    @_ignore('{"method": "Network.enable", "id": 0}')
    @_ignore('{"method": "Network.disable", "id": 0}')
    @_ignore('{"method": "Network.setUserAgentOverride", "params": {"userAgent": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "Network.setExtraHeaders", "params": {"headers": {"optional": false, "type": "object"}}, "id": 0}')
    @_ignore('{"method": "Network.getResourceContent", "params": {"requestId": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "Network.clearBrowserCache", "id": 0}')
    @_ignore('{"method": "Network.clearBrowserCookies", "id": 0}')
    @_ignore('{"method": "Network.setCacheDisabled", "params": {"cacheDisabled": {"optional": false, "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "Database.enable", "id": 0}')
    @_ignore('{"method": "Database.disable", "id": 0}')
    @_ignore('{"method": "Database.getDatabaseTableNames", "params": {"databaseId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "Database.executeSQL", "params": {"databaseId": {"optional": false, "type": "number"},"query": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMStorage.enable", "id": 0}')
    @_ignore('{"method": "DOMStorage.disable", "id": 0}')
    @_ignore('{"method": "DOMStorage.getDOMStorageEntries", "params": {"storageId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOMStorage.setDOMStorageItem", "params": {"storageId": {"optional": false, "type": "number"},"key": {"optional": false, "type": "string"},"value": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMStorage.removeDOMStorageItem", "params": {"storageId": {"optional": false, "type": "number"},"key": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "ApplicationCache.getApplicationCaches", "id": 0}')
    @_ignore('{"method": "DOM.getDocument", "id": 0}')
    @_ignore('{"method": "DOM.requestChildNodes", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOM.querySelector", "params": {"nodeId": {"optional": false, "type": "number"},"selector": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.querySelectorAll", "params": {"nodeId": {"optional": false, "type": "number"},"selector": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.setNodeName", "params": {"nodeId": {"optional": false, "type": "number"},"name": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.setNodeValue", "params": {"nodeId": {"optional": false, "type": "number"},"value": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.removeNode", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOM.setAttributeValue", "params": {"nodeId": {"optional": false, "type": "number"},"name": {"optional": false, "type": "string"},"value": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.setAttributesText", "params": {"nodeId": {"optional": false, "type": "number"},"text": {"optional": false, "type": "string"},"name": {"optional": true , "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.removeAttribute", "params": {"nodeId": {"optional": false, "type": "number"},"name": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.getEventListenersForNode", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOM.copyNode", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOM.getOuterHTML", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOM.setOuterHTML", "params": {"nodeId": {"optional": false, "type": "number"},"outerHTML": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.performSearch", "params": {"query": {"optional": false, "type": "string"},"runSynchronously": {"optional": true , "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "DOM.cancelSearch", "id": 0}')
    @_ignore('{"method": "DOM.requestNode", "params": {"objectId": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.setInspectModeEnabled", "params": {"enabled": {"optional": false, "type": "boolean"},"highlightConfig": {"optional": true , "type": "object"}}, "id": 0}')
    @_ignore('{"method": "DOM.highlightRect", "params": {"x": {"optional": false, "type": "number"},"y": {"optional": false, "type": "number"},"width": {"optional": false, "type": "number"},"height": {"optional": false, "type": "number"},"color": {"optional": true , "type": "object"},"outlineColor": {"optional": true , "type": "object"}}, "id": 0}')
    @_ignore('{"method": "DOM.highlightNode", "params": {"nodeId": {"optional": false, "type": "number"},"highlightConfig": {"optional": false, "type": "object"}}, "id": 0}')
    @_ignore('{"method": "DOM.hideHighlight", "id": 0}')
    @_ignore('{"method": "DOM.highlightFrame", "params": {"frameId": {"optional": false, "type": "string"},"contentColor": {"optional": true , "type": "object"},"contentOutlineColor": {"optional": true , "type": "object"}}, "id": 0}')
    @_ignore('{"method": "DOM.pushNodeByPathToFrontend", "params": {"path": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.resolveNode", "params": {"nodeId": {"optional": false, "type": "number"},"objectGroup": {"optional": true , "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOM.getAttributes", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "DOM.moveTo", "params": {"nodeId": {"optional": false, "type": "number"},"targetNodeId": {"optional": false, "type": "number"},"anchorNodeId": {"optional": true , "type": "number"}}, "id": 0}')
    @_ignore('{"method": "CSS.getStylesForNode", "params": {"nodeId": {"optional": false, "type": "number"},"forcedPseudoClasses": {"optional": true , "type": "object"}}, "id": 0}')
    @_ignore('{"method": "CSS.getComputedStyleForNode", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "CSS.getInlineStyleForNode", "params": {"nodeId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "CSS.getAllStyleSheets", "id": 0}')
    @_ignore('{"method": "CSS.getStyleSheet", "params": {"styleSheetId": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "CSS.getStyleSheetText", "params": {"styleSheetId": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "CSS.setStyleSheetText", "params": {"styleSheetId": {"optional": false, "type": "string"},"text": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "CSS.setPropertyText", "params": {"styleId": {"optional": false, "type": "object"},"propertyIndex": {"optional": false, "type": "number"},"text": {"optional": false, "type": "string"},"overwrite": {"optional": false, "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "CSS.toggleProperty", "params": {"styleId": {"optional": false, "type": "object"},"propertyIndex": {"optional": false, "type": "number"},"disable": {"optional": false, "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "CSS.setRuleSelector", "params": {"ruleId": {"optional": false, "type": "object"},"selector": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "CSS.addRule", "params": {"contextNodeId": {"optional": false, "type": "number"},"selector": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "CSS.getSupportedCSSProperties", "id": 0}')
    @_ignore('{"method": "DOMDebugger.setDOMBreakpoint", "params": {"nodeId": {"optional": false, "type": "number"},"type": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMDebugger.removeDOMBreakpoint", "params": {"nodeId": {"optional": false, "type": "number"},"type": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMDebugger.setEventListenerBreakpoint", "params": {"eventName": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMDebugger.removeEventListenerBreakpoint", "params": {"eventName": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMDebugger.setXHRBreakpoint", "params": {"url": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "DOMDebugger.removeXHRBreakpoint", "params": {"url": {"optional": false, "type": "string"}}, "id": 0}')
    @_ignore('{"method": "Worker.setWorkerInspectionEnabled", "params": {"value": {"optional": false, "type": "boolean"}}, "id": 0}')
    @_ignore('{"method": "Worker.sendMessageToWorker", "params": {"workerId": {"optional": false, "type": "number"},"message": {"optional": false, "type": "object"}}, "id": 0}')
    @_ignore('{"method": "Worker.connectToWorker", "params": {"workerId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "Worker.disconnectFromWorker", "params": {"workerId": {"optional": false, "type": "number"}}, "id": 0}')
    @_ignore('{"method": "Worker.setAutoconnectToWorkers", "params": {"value": {"optional": false, "type": "boolean"}}, "id": 0}')
    @_eventArgs["Inspector.frontendReused"] = []
    @_eventArgs["Inspector.bringToFront"] = []
    @_eventArgs["Inspector.disconnectFromBackend"] = []
    @_eventArgs["Inspector.reset"] = []
    @_eventArgs["Inspector.showPanel"] = ["panel"]
    @_eventArgs["Inspector.startUserInitiatedDebugging"] = []
    @_eventArgs["Inspector.evaluateForTestInFrontend"] = ["testCallId","script"]
    @_eventArgs["Inspector.inspect"] = ["object","hints"]
    @_eventArgs["Inspector.didCreateWorker"] = ["id","url","isShared"]
    @_eventArgs["Inspector.didDestroyWorker"] = ["id"]
    @_eventArgs["Page.domContentEventFired"] = ["timestamp"]
    @_eventArgs["Page.loadEventFired"] = ["timestamp"]
    @_eventArgs["Page.frameNavigated"] = ["frame","loaderId"]
    @_eventArgs["Page.frameDetached"] = ["frameId"]
    @_eventArgs["Console.messageAdded"] = ["messageObj"]
    @_eventArgs["Console.messageRepeatCountUpdated"] = ["count"]
    @_eventArgs["Console.messagesCleared"] = []
    @_eventArgs["Network.requestWillBeSent"] = ["requestId","frameId","loaderId","documentURL","request","timestamp","initiator","stackTrace","redirectResponse"]
    @_eventArgs["Network.resourceMarkedAsCached"] = ["requestId"]
    @_eventArgs["Network.resourceLoadedFromMemoryCache"] = ["requestId","frameId","loaderId","documentURL","timestamp","initiator","resource"]
    @_eventArgs["Network.webSocketWillSendHandshakeRequest"] = ["requestId","timestamp","request"]
    @_eventArgs["Network.webSocketHandshakeResponseReceived"] = ["requestId","timestamp","response"]
    @_eventArgs["Network.webSocketCreated"] = ["requestId","url"]
    @_eventArgs["Network.webSocketClosed"] = ["requestId","timestamp"]
    @_eventArgs["Database.addDatabase"] = ["database"]
    @_eventArgs["Database.sqlTransactionSucceeded"] = ["transactionId","columnNames","values"]
    @_eventArgs["Database.sqlTransactionFailed"] = ["transactionId","sqlError"]
    @_eventArgs["DOMStorage.addDOMStorage"] = ["storage"]
    @_eventArgs["DOMStorage.updateDOMStorage"] = ["storageId"]
    @_eventArgs["ApplicationCache.updateApplicationCacheStatus"] = ["status"]
    @_eventArgs["ApplicationCache.updateNetworkState"] = ["isNowOnline"]
    @_eventArgs["DOM.documentUpdated"] = []
    @_eventArgs["DOM.setChildNodes"] = ["parentId","nodes"]
    @_eventArgs["DOM.attributesUpdated"] = ["nodeId"]
    @_eventArgs["DOM.inlineStyleInvalidated"] = ["nodeIds"]
    @_eventArgs["DOM.characterDataModified"] = ["nodeId","newValue"]
    @_eventArgs["DOM.childNodeCountUpdated"] = ["nodeId","newValue"]
    @_eventArgs["DOM.childNodeInserted"] = ["parentNodeId","previousNodeId","node"]
    @_eventArgs["DOM.childNodeRemoved"] = ["parentNodeId","nodeId"]
    @_eventArgs["DOM.searchResults"] = ["nodeIds"]
    @_eventArgs["Debugger.debuggerWasEnabled"] = []
    @_eventArgs["Debugger.debuggerWasDisabled"] = []
    @_eventArgs["Debugger.scriptParsed"] = ["scriptId","url","startLine","startColumn","endLine","endColumn","isContentScript","sourceMapURL","hasSourceURL"]
    @_eventArgs["Debugger.scriptFailedToParse"] = ["url","data","firstLine","errorLine","errorMessage"]
    @_eventArgs["Debugger.breakpointResolved"] = ["breakpointId","location"]
    @_eventArgs["Debugger.paused"] = ["details"]
    @_eventArgs["Debugger.resumed"] = []
    @_eventArgs["Profiler.profilerWasEnabled"] = []
    @_eventArgs["Profiler.profilerWasDisabled"] = []
    @_eventArgs["Profiler.addProfileHeader"] = ["header"]
    @_eventArgs["Profiler.addHeapSnapshotChunk"] = ["uid","chunk"]
    @_eventArgs["Profiler.finishHeapSnapshot"] = ["uid"]
    @_eventArgs["Profiler.setRecordingProfile"] = ["isProfiling"]
    @_eventArgs["Profiler.resetProfiles"] = []
    @_eventArgs["Profiler.reportHeapSnapshotProgress"] = ["done","total"]
    @_eventArgs["Worker.workerCreated"] = ["workerId","url","inspectorConnected"]
    @_eventArgs["Worker.workerTerminated"] = ["workerId"]
    @_eventArgs["Worker.dispatchMessageFromWorker"] = ["workerId","message"]
    @registerInspectorDispatcher = @_registerDomainDispatcher.bind(this, "Inspector")
    @registerPageDispatcher = @_registerDomainDispatcher.bind(this, "Page")
    @registerConsoleDispatcher = @_registerDomainDispatcher.bind(this, "Console")
    @registerNetworkDispatcher = @_registerDomainDispatcher.bind(this, "Network")
    @registerDatabaseDispatcher = @_registerDomainDispatcher.bind(this, "Database")
    @registerDOMStorageDispatcher = @_registerDomainDispatcher.bind(this, "DOMStorage")
    @registerApplicationCacheDispatcher = @_registerDomainDispatcher.bind(this, "ApplicationCache")
    @registerDOMDispatcher = @_registerDomainDispatcher.bind(this, "DOM")
    @registerTimelineDispatcher = @_registerDomainDispatcher.bind(this, "Timeline")
    @registerDebuggerDispatcher = @_registerDomainDispatcher.bind(this, "Debugger")
    @registerProfilerDispatcher = @_registerDomainDispatcher.bind(this, "Profiler")
    @registerWorkerDispatcher = @_registerDomainDispatcher.bind(this, "Worker")
    @registerCSSDispatcher = @_registerDomainDispatcher.bind(this, "CSS")
    @registerRuntimeDispatcher = @_registerDomainDispatcher.bind(this, "Runtime")

  agent: (agentId, withContext) ->
    agentName = "#{agentId}Agent"
    _agent = window[agentName] ?= {}
    self = @
    ctx =
      ignore: (functionName) ->
        _agent[functionName] = ->
        _agent[functionName].invoke = (args, callback) ->
          console.warn "Invoked the ignored function: #{agentName}##{functionName}"
          callback()
        return ctx

      delegate: (functionName, params) ->
        requestString = JSON.stringify { method: "#{agentId}.#{functionName}", params: params }
        _agent[functionName] = self._sendMessageToBackend.bind self, requestString
        _agent[functionName].invoke = self._invoke.bind self, requestString
        return ctx

      event: (eventName, eventArgs) ->
        self._eventArgs["#{agentId}.#{eventName}"] = eventArgs
        return ctx

    withContext ctx

  _wrap: (callback) ->
      callbackId = @_lastCallbackId++
      @_callbacks[callbackId] = callback || ->
      return callbackId

  loadFromJSONIfNeeded: (jsonFile) ->
    # ignore

  _registerDelegate: (requestString) ->
      domainAndFunction = JSON.parse(requestString).method.split(".")
      agentName = domainAndFunction[0] + "Agent"
      if (!window[agentName])
          window[agentName] = {}
      window[agentName][domainAndFunction[1]] = @_sendMessageToBackend.bind(this, requestString)
      window[agentName][domainAndFunction[1]]["invoke"] = @_invoke.bind(this, requestString)

  _ignore: (requestString) ->
      domainAndFunction = JSON.parse(requestString).method.split(".")
      agentName = domainAndFunction[0] + "Agent"
      functionName = domainAndFunction[1]
      if (!window[agentName])
          window[agentName] = {}
      window[agentName][functionName] = ->
      window[agentName][functionName]["invoke"] = (args, callback) ->
          console.error("invoked the ignored function: " + functionName)
          callback()

  _invoke: (requestString, args, callback) ->
      request = JSON.parse(requestString)
      request.params = args
      @_wrapCallbackAndSendMessageObject(request, callback)

  _sendMessageToBackend: ->
      args = Array.prototype.slice.call(arguments)
      request = args.shift()
      request = JSON.parse(request) if 'string' is typeof request
      callback =
        if (args.length && typeof args[args.length - 1] is "function")
          args.pop()
        else
          0

      domainAndMethod = request.method.split(".")
      agentMethod = domainAndMethod[0] + "Agent." + domainAndMethod[1]

      hasParams = false
      if (request.params)
          for key of request.params
              typeName = request.params[key].type
              optionalFlag = request.params[key].optional

              if (args.length is 0 && !optionalFlag)
                  console.error("Protocol Error: Invalid number of arguments for method '" + agentMethod + "' call. It must have the next arguments '" + JSON.stringify(request.params) + "'.")
                  return

              value = args.shift()
              if (optionalFlag && typeof value is "undefined")
                  delete request.params[key]
                  continue

              if (typeof value isnt typeName)
                  console.error("Protocol Error: Invalid type of argument '" + key + "' for method '" + agentMethod + "' call. It must be '" + typeName + "' but it is '" + typeof value + "'.")
                  return

              request.params[key] = value
              hasParams = true

          unless hasParams
              delete request.params

      if (args.length is 1 && !callback)
          if (typeof args[0] isnt "undefined")
              console.error("Protocol Error: Optional callback argument for method '" + agentMethod + "' call must be a function but its type is '" + typeof args[0] + "'.")
              return

      @_wrapCallbackAndSendMessageObject(request, callback)

  _wrapCallbackAndSendMessageObject: (messageObject, callback) ->
      messageObject.id = @_wrap(callback || ->)

      if (window.dumpInspectorProtocolMessages)
          console.log("frontend: " + JSON.stringify(messageObject))

      ++@_pendingResponsesCount
      @sendMessageObjectToBackend(messageObject)

  sendMessageObjectToBackend: (messageObject) ->
      message = JSON.stringify(messageObject)
      InspectorFrontendHost.sendMessageToBackend(message)

  _registerDomainDispatcher: (domain, dispatcher) ->
      @_domainDispatchers[domain] = dispatcher

  dispatch: (message) ->
      if (window.dumpInspectorProtocolMessages)
        stringMessage = if message is 'string' then message else JSON.stringify(message)
        console.log("backend: " + stringMessage)

      messageObject = 
        if typeof message is "string"
          JSON.parse(message)
        else message

      if messageObject.id? > 0 # just a response for some request
          if (messageObject.error)
            errObj = new Error()

            for k, v of messageObject
              errObj[k] = v

            errObj.getDescription = ->
                return @description if @description?
                switch(@code)
                  when -32700 then "Parse error"
                  when -32600 then "Invalid Request"
                  when -32601 then "Method not found"
                  when -32602 then "Invalid params"
                  when -32603 then "Internal error"
                  when -32000 then "Server error"
                  else "Unknown error code"

            errObj.toString = ->
              dataPart = if @data then " #{@data.join(' ')}" else ''
              return @getDescription() + "(#{@code}): #{@message}.#{dataPart}"

            messageObject = errObj

            if messageObject.error.code isnt -32000
              @reportProtocolError messageObject

          args =
            if messageObject.result
              for key of messageObject.result
                messageObject.result[key]
            else
              []

          callback = @_callbacks[messageObject.id]
          if callback
              args.unshift messageObject.error
              callback.apply null, args
              --@_pendingResponsesCount
              delete @_callbacks[messageObject.id]

          if @_scripts && !@_pendingResponsesCount
              @runAfterPendingDispatches()
      else
        if messageObject.type is 'event'
          console.error 'Unexpected event from socket.io: ', messageObject
          return

        [domainName, functionName] = messageObject.method.split(".")

        unless @_domainDispatchers[domainName]?
          return console.error "Protocol Error: the message is for non-existing domain '#{domainName}'"

        dispatcher = @_domainDispatchers[domainName]
        unless dispatcher[functionName]?
          return console.error "Protocol Error: Attempted to dispatch an unimplemented method '#{messageObject.method}'"

        unless @_eventArgs[messageObject.method]
          return console.error "Protocol Error: Attempted to dispatch an unspecified method '#{messageObject.method}'"

        params = []
        if messageObject.params
          paramNames = @_eventArgs[messageObject.method]
          for paramName in paramNames
            params.push messageObject.params[paramName]

        dispatcher[functionName].apply dispatcher, params

  reportProtocolError: (messageObject) ->
      console.error("Request with id = " + messageObject.id + " failed. " + messageObject.error)

  runAfterPendingDispatches: (script) ->
      if (!@_scripts)
          @_scripts = []

      if (script)
          @_scripts.push(script)

      if (!@_pendingResponsesCount)
          scripts = @_scripts
          @_scripts = []
          for script in scripts
               script.call(this)

window.InspectorBackend = new InspectorBackendStub()
