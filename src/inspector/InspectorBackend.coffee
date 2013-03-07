
console.log 'InspectorBackend.js', window.InspectorFrontendHost

document.title = 'bugger'

window.InspectorBackend =
  loadFromJSONIfNeeded: (jsonFile) ->
    console.log 'InspectorBackend#loadFromJSONIfNeeded', { jsonFile }

  registerWorkerDispatcher: (workerDispatcher) ->
    console.log 'InspectorBackend#registerWorkerDispatcher', { workerDispatcher }

  registerConsoleDispatcher: (consoleDispatcher) ->
    console.log 'InspectorBackend#registerConsoleDispatcher', { consoleDispatcher }

  registerNetworkDispatcher: (networkDispatcher) ->
    console.log 'InspectorBackend#registerNetworkDispatcher', { networkDispatcher }

  registerPageDispatcher: (pageDispatcher) ->
    console.log 'InspectorBackend#registerPageDispatcher', { pageDispatcher }

  registerDebuggerDispatcher: (debuggerDispatcher) ->
    console.log 'InspectorBackend#registerDebuggerDispatcher', { debuggerDispatcher }

  registerDOMDispatcher: (domDispatcher) ->
    console.log 'InspectorBackend#registerDOMDispatcher', { domDispatcher }

  registerInspectorDispatcher: (inspector) ->
    console.log 'InspectorBackend#registerInspectorDispatcher', { inspector }

  registerCSSDispatcher: (cssDispatcher) ->
    console.log 'InspectorBackend#registerCSSDispatcher', { cssDispatcher }

  registerTimelineDispatcher: (timelineDispatcher) ->
    console.log 'InspectorBackend#registerTimelineDispatcher', { timelineDispatcher }

  registerDatabaseDispatcher: (databaseDispatcher) ->
    console.log 'InspectorBackend#registerDatabaseDispatcher', { databaseDispatcher }

  registerDOMStorageDispatcher: (domStorageDispatcher) ->
    console.log 'InspectorBackend#registerDOMStorageDispatcher', { domStorageDispatcher }

  registerProfilerDispatcher: (profilerDispatcher) ->
    console.log 'InspectorBackend#registerProfilerDispatcher', { profilerDispatcher }

window.WorkerAgent =
  enable: ->
    console.log 'WorkerAgent#enable'

window.IndexedDBAgent =
  enable: ->
    console.log 'IndexedDBAgent#enable'

window.DOMAgent =
  getDocument: (fn) ->
    domAgentDocument = document.createElement 'html'
    domAgentDocument.nodeId = 'my_nodeId'
    domAgentDocument.innerHTML = '<body><li>Element</li></body>'
    domAgentDocument.baseURL = 'http://localhost:8058'
    # domAgentDocument =
    #   nodeId: 'my_nodeId'
    #   documentURL: 'some_url'
    #   baseURL: 'some_base_url'
    #   xmlVersion: '1.0'
    #   nodeType: 'nodeType'
    #   nodeName: 'nodeName'
    #   localName: 'localName'
    #   nodeValue: 'nodeValue'
    #   attributes: { someattr: 'some-attr' }
    #   childNodeCount: 10
    #   templateContent: 'templateContent'
    #   shadowRoots: null
    #   children: [ {} ]
      # contentDocument: 'contentDocument'

    console.log 'DOMAgent#getDocument', { fn }
    fn null, domAgentDocument

  resolveNode: (nodeId, objectGroup, mycallback) ->
    console.log 'DOMAgent#resolveNode', { nodeId, objectGroup, mycallback }

  getEventListenersForNode: (nodeId, objectGroupId, callback) ->
    console.log 'DOMAgent#getEventListenersForNode', { nodeId, objectGroupId, callback }

  highlightNode: (highlightConfig, nodeIdUnlessObjectId, objectId) ->
    console.log 'DOMAgent#highlightNode', { highlightConfig, nodeIdUnlessObjectId, objectId }

  hideHighlight: ->
    console.log 'DOMAgent#hideHighlight'

  setInspectModeEnabled: (enabled, highlightConfig, callback) ->
    console.log 'DOMAgent#setInspectModeEnabled', { enabled, highlightConfig, callback }

window.DOMStorageAgent =
  enable: ->
    console.log 'DOMStorageAgent#enable'

window.DatabaseAgent =
  enable: ->
    console.log 'DatabaseAgent#enable'

window.ConsoleAgent =
  enable: ->
    console.log 'ConsoleAgent#enable'

  addInspectedNode: (selectedNodeId) ->
    console.log 'ConsoleAgent#addInspectedNode', { selectedNodeId }

window.InspectorAgent =
  enable: (showInitialPanel) ->
    console.log 'InspectorAgent#enable', { showInitialPanel }

window.RuntimeAgent =
  releaseObjectGroup: (watchObjectGroupId) ->
    console.log 'RuntimeAgent#releaseObjectGroup', { watchObjectGroupId }

  evaluate: (expression, objectGroup, includeCommandLineAPI, doNotPauseOnExceptionsAndMuteConsole, currentExecutionContextId, returnByValue, generatePreview, evalCallback) ->
    console.log 'RuntimeAgent#evaluate', { expression, objectGroup, includeCommandLineAPI, doNotPauseOnExceptionsAndMuteConsole, currentExecutionContextId, returnByValue, generatePreview, evalCallback }

window.NetworkAgent =
  enable: ->
    console.log 'NetworkAgent#enable'

  canClearBrowserCache: (fn) ->
    console.log 'NetworkAgent#canClearBrowserCache', { fn }

  canClearBrowserCookies: (fn) ->
    console.log 'NetworkAgent#canClearBrowserCookies', { fn }

window.CSSAgent =
  getSupportedCSSProperties: (fn) ->
    console.log 'CSSAgent#getSupportedCSSProperties', { fn }

  enable: ->
    console.log 'NetworkAgent#enable'

  getAllStyleSheets: (allStylesCallback) ->
    console.log 'CSSAgent#getAllStyleSheets', { allStylesCallback }

  getInlineStylesForNode: (nodeId, userCallback) ->
    console.log 'CSSAgent#getInlineStylesForNode', { nodeId, userCallback }

  getMatchedStylesForNode: (nodeId, needPseudo, needInherited, userCallback) ->
    console.log 'CSSAgent#getMatchedStylesForNode', { nodeId, needPseudo, needInherited, userCallback }

  getComputedStyleForNode: (nodeId, userCallback) ->
    console.log 'CSSAgent#getComputedStyleForNode', { nodeId, userCallback }

window.DebuggerAgent =
  causesRecompilation: (fn) ->
    console.log 'DebuggerAgent#causesRecompilation', { fn }

  supportsSeparateScriptCompilationAndExecution: (fn) ->
    console.log 'DebuggerAgent#supportsSeparateScriptCompilationAndExecution', { fn }

  canSetScriptSource: (fn) ->
    console.log 'DebuggerAgent#canSetScriptSource', { fn }

  enable: (onDebuggerWasEnabled) ->
    console.log 'DebuggerAgent#enable', { onDebuggerWasEnabled }

  disable: (onDebuggerWasDisabled) ->
    console.log 'DebuggerAgent#disable', { onDebuggerWasDisabled }

window.ProfilerAgent =
  causesRecompilation: (fn) ->
    console.log 'ProfilerAgent#causesRecompilation', { fn }

  isSampling: (fn) ->
    console.log 'ProfilerAgent#isSampling', { fn }

  enable: (onProfilerWasEnabled) ->
    console.log 'ProfilerAgent#enable', { onProfilerWasEnabled }

  disable: (onProfilerWasDisabled) ->
    console.log 'ProfilerAgent#disable', { onProfilerWasDisabled }

window.HeapProfilerAgent =
  hasHeapProfiler: (fn) ->
    console.log 'HeapProfilerAgent#hasHeapProfiler', { fn }

window.TimelineAgent =
  supportsFrameInstrumentation: (fn) ->
    console.log 'TimelineAgent#supportsFrameInstrumentation', { fn }

  canMonitorMainThread: (fn) ->
    console.log 'TimelineAgent#canMonitorMainThread', { fn }

  setIncludeDomCounters: (includeDomCounters) ->
    console.log 'TimelineAgent#setIncludeDomCounters', { includeDomCounters }

window.PageAgent =
  canShowDebugBorders: (fn) ->
    console.log 'PageAgent#canShowDebugBorders', { fn }

  canShowFPSCounter: (fn) ->
    console.log 'PageAgent#canShowFPSCounter', { fn }

  canContinuouslyPaint: (fn) ->
    console.log 'PageAgent#canContinuouslyPaint', { fn }

  canOverrideDeviceMetrics: (fn) ->
    console.log 'PageAgent#canOverrideDeviceMetrics', { fn }

  canOverrideGeolocation: (fn) ->
    console.log 'PageAgent#canOverrideGeolocation', { fn }

  canOverrideDeviceOrientation: (fn) ->
    console.log 'PageAgent#canOverrideDeviceOrientation', { fn }

  enable: ->
    console.log 'PageAgent#enable'

  getResourceTree: (fn) ->
    console.log 'PageAgent#getResourceTree', { fn }

  setTouchEmulationEnabled: (emulationEnabled) ->
    console.log 'PageAgent#setTouchEmulationEnabled', { emulationEnabled }

  # mycallback(error, cookies, cookiesString)
  getCookies: (mycallback) ->
    console.log 'PageAgent#getCookies', { mycallback }
