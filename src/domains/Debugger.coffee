# Domain bindings for Debugger
{EventEmitter} = require 'events'

module.exports = ({debugClient}) ->
  Debugger = new EventEmitter()

  sources = {}

  handleBreakEvent = ->
    debugClient.backtrace {inlineRefs: true}, (err, data) ->
      return null if err?
      {callFrames} = data
      Debugger.emit_paused {callFrames, reason: 'other'}

  # Tells whether enabling debugger causes scripts recompilation.
  #
  # @returns result boolean True if enabling debugger causes scripts recompilation.
  Debugger.causesRecompilation = ({}, cb) ->
    cb null, result: false

  # Tells whether debugger supports separate script compilation and execution.
  #
  # @returns result boolean True if debugger supports separate script compilation and execution.
  Debugger.supportsSeparateScriptCompilationAndExecution = ({}, cb) ->
    cb null, result: false

  # Enables debugger for the given page. Clients should not assume that the debugging has been enabled until the result for this command is received.
  Debugger.enable = ({}, cb) ->
    debugClient.on 'break', handleBreakEvent

    debugClient.scripts {includeSource: true}, (err, scripts) ->
      handleBreakEvent() unless debugClient.running

      Debugger.emit_scriptParsed(script) for script in scripts
      cb()

  # Disables debugger for given page.
  Debugger.disable = ({}, cb) ->
    # Not implemented

  # Activates / deactivates all breakpoints on the page.
  #
  # @param active boolean New value for breakpoints active state.
  Debugger.setBreakpointsActive = ({active}, cb) ->
    # Not implemented

  # Sets JavaScript breakpoint at given location specified either by URL or URL regex. Once this command is issued, all existing parsed scripts will have breakpoints resolved and returned in <code>locations</code> property. Further matching script parsing will result in subsequent <code>breakpointResolved</code> events issued. This logical breakpoint will survive page reloads.
  #
  # @param lineNumber integer Line number to set breakpoint at.
  # @param url string? URL of the resources to set breakpoint on.
  # @param urlRegex string? Regex pattern for the URLs of the resources to set breakpoints on. Either <code>url</code> or <code>urlRegex</code> must be specified.
  # @param columnNumber integer? Offset in the line to set breakpoint at.
  # @param condition string? Expression to use as a breakpoint condition. When specified, debugger will only stop on the breakpoint if this expression evaluates to true.
  # @returns breakpointId BreakpointId Id of the created breakpoint for further reference.
  # @returns locations Location[] List of the locations this breakpoint resolved into upon addition.
  Debugger.setBreakpointByUrl = ({lineNumber, url, urlRegex, columnNumber, condition}, cb) ->
    breakpointDesc = { line: lineNumber, column: columnNumber, condition }
    if urlRegex?
      breakpointDesc.type = 'scriptRegExp'
      breakpointDesc.target = urlRegex
    else
      breakpointDesc.type = 'script'
      breakpointDesc.target = url.replace(/^file:\/\//, '')

    debugClient.setbreakpoint breakpointDesc, (err, data) ->
      return cb(err) if err?
      cb null,
        breakpointId: data.breakpoint.toString()
        locations: data.actual_locations.map (l) ->
          { scriptId: l.script_id.toString(), lineNumber: l.line, columnNumber: l.column }

  # Sets JavaScript breakpoint at a given location.
  #
  # @param location Location Location to set breakpoint in.
  # @param condition string? Expression to use as a breakpoint condition. When specified, debugger will only stop on the breakpoint if this expression evaluates to true.
  # @returns breakpointId BreakpointId Id of the created breakpoint for further reference.
  # @returns actualLocation Location Location this breakpoint resolved into.
  Debugger.setBreakpoint = ({location, condition}, cb) ->
    # Not implemented

  # Removes JavaScript breakpoint.
  #
  # @param breakpointId BreakpointId 
  Debugger.removeBreakpoint = ({breakpointId}, cb) ->
    debugClient.clearbreakpoint {breakpoint: breakpointId}, (err, data) -> cb()

  # Continues execution until specific location is reached.
  #
  # @param location Location Location to continue to.
  Debugger.continueToLocation = ({location}, cb) ->
    # Not implemented

  # Steps over the statement.
  Debugger.stepOver = ({}, cb) ->
    debugClient.continue {stepaction: 'next'}, cb

  # Steps into the function call.
  Debugger.stepInto = ({}, cb) ->
    debugClient.continue {stepaction: 'in'}, cb

  # Steps out of the function call.
  Debugger.stepOut = ({}, cb) ->
    debugClient.continue {stepaction: 'out'}, cb

  # Stops on the next JavaScript statement.
  Debugger.pause = ({}, cb) ->
    # Not implemented
    debugClient.suspend {}, cb

  # Resumes JavaScript execution.
  Debugger.resume = ({}, cb) ->
    debugClient.continue {}, cb

  # Searches for given string in script content.
  #
  # @param scriptId ScriptId Id of the script to search in.
  # @param query string String to search for.
  # @param caseSensitive boolean? If true, search is case sensitive.
  # @param isRegex boolean? If true, treats string parameter as regex.
  # @returns result Page.SearchMatch[] List of search matches.
  Debugger.searchInContent = ({scriptId, query, caseSensitive, isRegex}, cb) ->
    # Not implemented

  # Tells whether <code>setScriptSource</code> is supported.
  #
  # @returns result boolean True if <code>setScriptSource</code> is supported.
  Debugger.canSetScriptSource = ({}, cb) ->
    cb null, result: true

  # Edits JavaScript source live.
  #
  # @param scriptId ScriptId Id of the script to edit.
  # @param scriptSource string New content of the script.
  # @param preview boolean?  If true the change will not actually be applied. Preview mode may be used to get result description without actually modifying the code.
  # @returns callFrames CallFrame[]? New stack trace in case editing has happened while VM was stopped.
  # @returns result object? VM-specific description of the changes applied.
  Debugger.setScriptSource = ({scriptId, scriptSource, preview}, cb) ->
    # Not implemented

  # Restarts particular call frame from the beginning.
  #
  # @param callFrameId CallFrameId Call frame identifier to evaluate on.
  # @returns callFrames CallFrame[] New stack trace.
  # @returns result object VM-specific description.
  Debugger.restartFrame = ({callFrameId}, cb) ->
    # Not implemented

  # Returns source for the script with given id.
  #
  # @param scriptId ScriptId Id of the script to get source for.
  # @returns scriptSource string Script source.
  Debugger.getScriptSource = ({scriptId}, cb) ->
    if sources[scriptId]?
      return cb null, scriptSource: sources[scriptId]

    ids = [scriptId]
    debugClient.scripts {filter: scriptId, includeSource: true}, (err, [script]) ->
      cb err, script

  # Returns detailed informtation on given function.
  #
  # @param functionId Runtime.RemoteObjectId Id of the function to get location for.
  # @returns details FunctionDetails Information about the function.
  Debugger.getFunctionDetails = ({functionId}, cb) ->
    # Not implemented

  # Defines pause on exceptions state. Can be set to stop on all exceptions, uncaught exceptions or no exceptions. Initial pause on exceptions state is <code>none</code>.
  #
  # @param state none|uncaught|all Pause on exceptions mode.
  Debugger.setPauseOnExceptions = ({state}, cb) ->
    # Not implemented

  # Evaluates expression on a given call frame.
  #
  # @param callFrameId CallFrameId Call frame identifier to evaluate on.
  # @param expression string Expression to evaluate.
  # @param objectGroup string? String object group name to put result into (allows rapid releasing resulting object handles using <code>releaseObjectGroup</code>).
  # @param includeCommandLineAPI boolean? Specifies whether command line API should be available to the evaluated expression, defaults to false.
  # @param doNotPauseOnExceptionsAndMuteConsole boolean? Specifies whether evaluation should stop on exceptions and mute console. Overrides setPauseOnException state.
  # @param returnByValue boolean? Whether the result is expected to be a JSON object that should be sent by value.
  # @param generatePreview boolean? Whether preview should be generated for the result.
  # @returns result Runtime.RemoteObject Object wrapper for the evaluation result.
  # @returns wasThrown boolean? True if the result was thrown during the evaluation.
  Debugger.evaluateOnCallFrame = ({callFrameId, expression, objectGroup, includeCommandLineAPI, doNotPauseOnExceptionsAndMuteConsole, returnByValue, generatePreview}, cb) ->
    params = { expression, global: false, frame: callFrameId, disable_break: doNotPauseOnExceptionsAndMuteConsole }
    debugClient.evaluate params, (err, res) ->
      if err?
        { message, stack } = err
        return cb null, result: { type: 'string', value: message }, wasThrown: true
      else
        return cb null, result: res

  # Compiles expression.
  #
  # @param expression string Expression to compile.
  # @param sourceURL string Source url to be set for the script.
  # @returns scriptId ScriptId? Id of the script.
  # @returns syntaxErrorMessage string? Syntax error message if compilation failed.
  Debugger.compileScript = ({expression, sourceURL}, cb) ->
    # Not implemented

  # Runs script with given id in a given context.
  #
  # @param scriptId ScriptId Id of the script to run.
  # @param contextId Runtime.ExecutionContextId? Specifies in which isolated context to perform script run. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
  # @param objectGroup string? Symbolic group name that can be used to release multiple objects.
  # @param doNotPauseOnExceptionsAndMuteConsole boolean? Specifies whether script run should stop on exceptions and mute console. Overrides setPauseOnException state.
  # @returns result Runtime.RemoteObject Run result.
  # @returns wasThrown boolean? True if the result was thrown during the script run.
  Debugger.runScript = ({scriptId, contextId, objectGroup, doNotPauseOnExceptionsAndMuteConsole}, cb) ->
    # Not implemented

  # Sets overlay message.
  #
  # @param message string? Overlay message to display when paused in debugger.
  Debugger.setOverlayMessage = ({message}, cb) ->
    # This just gets stupid. Too much noise.
    cb()

  # Changes value of variable in a callframe or a closure. Either callframe or function must be specified. Object-based scopes are not supported and must be mutated manually.
  #
  # @param scopeNumber integer 0-based number of scope as was listed in scope chain. Only 'local', 'closure' and 'catch' scope types are allowed. Other scopes could be manipulated manually.
  # @param variableName string Variable name.
  # @param newValue Runtime.CallArgument New variable value.
  # @param callFrameId CallFrameId? Id of callframe that holds variable.
  # @param functionObjectId Runtime.RemoteObjectId? Object id of closure (function) that holds variable.
  Debugger.setVariableValue = ({scopeNumber, variableName, newValue, callFrameId, functionObjectId}, cb) ->
    # Not implemented

  # Called when global has been cleared and debugger client should reset its state. Happens upon navigation or reload.
  Debugger.emit_globalObjectCleared = (params) ->
    notification = {params, method: 'Debugger.globalObjectCleared'}
    @emit 'notification', notification

  # Fired when virtual machine parses script. This event is also fired for all known and uncollected scripts upon enabling debugger.
  #
  # @param scriptId ScriptId Identifier of the script parsed.
  # @param url string URL or name of the script parsed (if any).
  # @param startLine integer Line offset of the script within the resource with given URL (for script tags).
  # @param startColumn integer Column offset of the script within the resource with given URL.
  # @param endLine integer Last line of the script.
  # @param endColumn integer Length of the last line of the script.
  # @param isContentScript boolean? Determines whether this script is a user extension script.
  # @param sourceMapURL string? URL of source map associated with script (if any).
  # @param hasSourceURL boolean? True, if this script has sourceURL.
  Debugger.emit_scriptParsed = (script) ->
    if script.scriptSource?
      sources[script.scriptId] = script.scriptSource
      # We don't delete the script here so the server can intercept the source
      # and he may extract source maps

    notification = {params: script, method: 'Debugger.scriptParsed'}
    @emit 'notification', notification

  # Fired when virtual machine fails to parse the script.
  #
  # @param url string URL of the script that failed to parse.
  # @param scriptSource string Source text of the script that failed to parse.
  # @param startLine integer Line offset of the script within the resource.
  # @param errorLine integer Line with error.
  # @param errorMessage string Parse error message.
  Debugger.emit_scriptFailedToParse = (params) ->
    notification = {params, method: 'Debugger.scriptFailedToParse'}
    @emit 'notification', notification

  # Fired when breakpoint is resolved to an actual script and location.
  #
  # @param breakpointId BreakpointId Breakpoint unique identifier.
  # @param location Location Actual breakpoint location.
  Debugger.emit_breakpointResolved = (params) ->
    notification = {params, method: 'Debugger.breakpointResolved'}
    @emit 'notification', notification

  # Fired when the virtual machine stopped on breakpoint or exception or any other stop criteria.
  #
  # @param callFrames CallFrame[] Call stack the virtual machine stopped on.
  # @param reason XHR|DOM|EventListener|exception|assert|CSPViolation|other Pause reason.
  # @param data object? Object containing break-specific auxiliary properties.
  Debugger.emit_paused = (params) ->
    notification = {params, method: 'Debugger.paused'}
    @emit 'notification', notification

  # Fired when the virtual machine resumed execution.
  Debugger.emit_resumed = (params) ->
    notification = {params, method: 'Debugger.resumed'}
    @emit 'notification', notification

  # # Types
  # Breakpoint identifier.
  Debugger.BreakpointId = {"id":"BreakpointId","type":"string","description":"Breakpoint identifier."}
  # Unique script identifier.
  Debugger.ScriptId = {"id":"ScriptId","type":"string","description":"Unique script identifier."}
  # Call frame identifier.
  Debugger.CallFrameId = {"id":"CallFrameId","type":"string","description":"Call frame identifier."}
  # Location in the source code.
  Debugger.Location = {"id":"Location","type":"object","properties":[{"name":"scriptId","$ref":"ScriptId","description":"Script identifier as reported in the <code>Debugger.scriptParsed</code>."},{"name":"lineNumber","type":"integer","description":"Line number in the script."},{"name":"columnNumber","type":"integer","optional":true,"description":"Column number in the script."}],"description":"Location in the source code."}
  # Information about the function.
  Debugger.FunctionDetails = {"id":"FunctionDetails","hidden":true,"type":"object","properties":[{"name":"location","$ref":"Location","description":"Location of the function."},{"name":"name","type":"string","optional":true,"description":"Name of the function. Not present for anonymous functions."},{"name":"displayName","type":"string","optional":true,"description":"Display name of the function(specified in 'displayName' property on the function object)."},{"name":"inferredName","type":"string","optional":true,"description":"Name of the function inferred from its initial assignment."},{"name":"scopeChain","type":"array","optional":true,"items":{"$ref":"Scope"},"description":"Scope chain for this closure."}],"description":"Information about the function."}
  # JavaScript call frame. Array of call frames form the call stack.
  Debugger.CallFrame = {"id":"CallFrame","type":"object","properties":[{"name":"callFrameId","$ref":"CallFrameId","description":"Call frame identifier. This identifier is only valid while the virtual machine is paused."},{"name":"functionName","type":"string","description":"Name of the JavaScript function called on this call frame."},{"name":"location","$ref":"Location","description":"Location in the source code."},{"name":"scopeChain","type":"array","items":{"$ref":"Scope"},"description":"Scope chain for this call frame."},{"name":"this","$ref":"Runtime.RemoteObject","description":"<code>this</code> object for this call frame."}],"description":"JavaScript call frame. Array of call frames form the call stack."}
  # Scope description.
  Debugger.Scope = {"id":"Scope","type":"object","properties":[{"name":"type","type":"string","enum":["global","local","with","closure","catch"],"description":"Scope type."},{"name":"object","$ref":"Runtime.RemoteObject","description":"Object representing the scope. For <code>global</code> and <code>with</code> scopes it represents the actual object; for the rest of the scopes, it is artificial transient object enumerating scope variables as its properties."}],"description":"Scope description."}

  return Debugger
