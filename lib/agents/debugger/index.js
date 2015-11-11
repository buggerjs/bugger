'use strict';

const vm = require('vm');

const debug = require('debug')('embedded-agents:debugger');

const BaseAgent = require('../base');

const UrlMapper = require('../../url-mapper');

const Debug = vm.runInDebugContext('Debug');

class DebuggerAgent extends BaseAgent {
  constructor() {
    super();
    this._scriptCache = {};
  }

  _onAfterCompile(event) {
    this._registerScript(event.script());
  }

  _registerScript(raw) {
    const context = null;
    const script = {
      scriptId: '' + raw.id(),
      url: UrlMapper.scriptUrlFromName(raw.name()),
      lineCount: raw.lineCount(),
      sourceOffset: { line: raw.lineOffset(), column: raw.columnOffset() },
      context: context,
      evalContext: null,
    };
    this._scriptCache[script.scriptId] = raw;
    debug('Found script', script.url || script.scriptId);
    this.emit('scriptParsed', script);
  }

  /**
   * Enables debugger for the given page.
   * Clients should not assume that the debugging has been enabled until the result for this command is received.
   */
  enable() {
    const scripts = Debug.scripts().map(Debug.MakeMirror);
    debug('Dispatching %d scripts', scripts.length);
    scripts.forEach(this._registerScript, this);
  }

  /**
   * Disables debugger for given page.
   */
  disable() {
    throw new Error('Not implemented');
  }

  /**
   * Activates / deactivates all breakpoints on the page.
   *
   * @param {boolean} active New value for breakpoints active state.
   */
  setBreakpointsActive() {
    throw new Error('Not implemented');
  }

  /**
   * Makes page not interrupt on any pauses (breakpoint, exception, dom exception etc).
   *
   * @param {boolean} skipped New value for skip pauses state.
   */
  setSkipAllPauses() {
    throw new Error('Not implemented');
  }

  /**
   * Sets JavaScript breakpoint at given location specified either by URL or URL regex.
   * Once this command is issued, all existing parsed scripts will have breakpoints resolved and returned in <code>locations</code> property.
   * Further matching script parsing will result in subsequent <code>breakpointResolved</code> events issued.
   * This logical breakpoint will survive page reloads.
   *
   * @param {integer} lineNumber Line number to set breakpoint at.
   * @param {string=} url URL of the resources to set breakpoint on.
   * @param {string=} urlRegex Regex pattern for the URLs of the resources to set breakpoints on. Either <code>url</code> or <code>urlRegex</code> must be specified.
   * @param {integer=} columnNumber Offset in the line to set breakpoint at.
   * @param {string=} condition Expression to use as a breakpoint condition. When specified, debugger will only stop on the breakpoint if this expression evaluates to true.
   *
   * @returns {BreakpointId} breakpointId Id of the created breakpoint for further reference.
   * @returns {Array.<Location>} locations List of the locations this breakpoint resolved into upon addition.
   */
  setBreakpointByUrl() {
    throw new Error('Not implemented');
  }

  /**
   * Sets JavaScript breakpoint at a given location.
   *
   * @param {Location} location Location to set breakpoint in.
   * @param {string=} condition Expression to use as a breakpoint condition. When specified, debugger will only stop on the breakpoint if this expression evaluates to true.
   *
   * @returns {BreakpointId} breakpointId Id of the created breakpoint for further reference.
   * @returns {Location} actualLocation Location this breakpoint resolved into.
   */
  setBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Removes JavaScript breakpoint.
   *
   * @param {BreakpointId} breakpointId
   */
  removeBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Continues execution until specific location is reached.
   *
   * @param {Location} location Location to continue to.
   * @param {boolean=} interstatementLocation Allows breakpoints at the intemediate positions inside statements.
   */
  continueToLocation() {
    throw new Error('Not implemented');
  }

  /**
   * Steps over the statement.
   */
  stepOver() {
    throw new Error('Not implemented');
  }

  /**
   * Steps into the function call.
   */
  stepInto() {
    throw new Error('Not implemented');
  }

  /**
   * Steps out of the function call.
   */
  stepOut() {
    throw new Error('Not implemented');
  }

  /**
   * Stops on the next JavaScript statement.
   */
  pause() {
    throw new Error('Not implemented');
  }

  /**
   * Resumes JavaScript execution.
   */
  resume() {
    throw new Error('Not implemented');
  }

  /**
   * Steps into the first async operation handler that was scheduled by or after the current statement.
   */
  stepIntoAsync() {
    throw new Error('Not implemented');
  }

  /**
   * Searches for given string in script content.
   *
   * @param {ScriptId} scriptId Id of the script to search in.
   * @param {string} query String to search for.
   * @param {boolean=} caseSensitive If true, search is case sensitive.
   * @param {boolean=} isRegex If true, treats string parameter as regex.
   *
   * @returns {Array.<SearchMatch>} result List of search matches.
   */
  searchInContent() {
    throw new Error('Not implemented');
  }

  /**
   * Always returns true.
   *
   * @returns {boolean} result True if <code>setScriptSource</code> is supported.
   */
  canSetScriptSource() {
    throw new Error('Not implemented');
  }

  /**
   * Edits JavaScript source live.
   *
   * @param {ScriptId} scriptId Id of the script to edit.
   * @param {string} scriptSource New content of the script.
   * @param {boolean=} preview  If true the change will not actually be applied. Preview mode may be used to get result description without actually modifying the code.
   *
   * @returns {Array.<CallFrame>=} callFrames New stack trace in case editing has happened while VM was stopped.
   * @returns {boolean=} stackChanged Whether current call stack  was modified after applying the changes.
   * @returns {StackTrace=} asyncStackTrace Async stack trace, if any.
   *
   * @throws {SetScriptSourceError}
   */
  setScriptSource() {
    throw new Error('Not implemented');
  }

  /**
   * Restarts particular call frame from the beginning.
   *
   * @param {CallFrameId} callFrameId Call frame identifier to evaluate on.
   *
   * @returns {Array.<CallFrame>} callFrames New stack trace.
   * @returns {StackTrace=} asyncStackTrace Async stack trace, if any.
   */
  restartFrame() {
    throw new Error('Not implemented');
  }

  /**
   * Returns source for the script with given id.
   *
   * @param {ScriptId} scriptId Id of the script to get source for.
   *
   * @returns {string} scriptSource Script source.
   */
  getScriptSource(params) {
    const script = this._scriptCache[params.scriptId];
    // TOOD: handle script cache miss
    return { scriptSource: script.source() };
  }

  /**
   * Returns detailed information on given function.
   *
   * @param {Runtime.RemoteObjectId} functionId Id of the function to get details for.
   *
   * @returns {FunctionDetails} details Information about the function.
   */
  getFunctionDetails() {
    throw new Error('Not implemented');
  }

  /**
   * Returns detailed information on given generator object.
   *
   * @param {Runtime.RemoteObjectId} objectId Id of the generator object to get details for.
   *
   * @returns {GeneratorObjectDetails} details Information about the generator object.
   */
  getGeneratorObjectDetails() {
    throw new Error('Not implemented');
  }

  /**
   * Returns entries of given collection.
   *
   * @param {Runtime.RemoteObjectId} objectId Id of the collection to get entries for.
   *
   * @returns {Array.<CollectionEntry>} entries Array of collection entries.
   */
  getCollectionEntries() {
    throw new Error('Not implemented');
  }

  /**
   * Defines pause on exceptions state.
   * Can be set to stop on all exceptions, uncaught exceptions or no exceptions.
   * Initial pause on exceptions state is <code>none</code>.
   *
   * @param {string none|uncaught|all} state Pause on exceptions mode.
   */
  setPauseOnExceptions(params) {
    switch (params.state) {
    case 'none':
      Debug.clearBreakOnException();
      Debug.clearBreakOnUncaughtException();
      break;

    case 'uncaught':
      Debug.clearBreakOnException();
      Debug.setBreakOnUncaughtException();
      break;

    case 'all':
      Debug.setBreakOnException();
      Debug.clearBreakOnUncaughtException();
      break;

    default:
      throw new Error(`Unexpected pause state: ${params.state}`);
    }
  }

  /**
   * Evaluates expression on a given call frame.
   *
   * @param {CallFrameId} callFrameId Call frame identifier to evaluate on.
   * @param {string} expression Expression to evaluate.
   * @param {string=} objectGroup String object group name to put result into (allows rapid releasing resulting object handles using <code>releaseObjectGroup</code>).
   * @param {boolean=} includeCommandLineAPI Specifies whether command line API should be available to the evaluated expression, defaults to false.
   * @param {boolean=} doNotPauseOnExceptionsAndMuteConsole Specifies whether evaluation should stop on exceptions and mute console. Overrides setPauseOnException state.
   * @param {boolean=} returnByValue Whether the result is expected to be a JSON object that should be sent by value.
   * @param {boolean=} generatePreview Whether preview should be generated for the result.
   *
   * @returns {Runtime.RemoteObject} result Object wrapper for the evaluation result.
   * @returns {boolean=} wasThrown True if the result was thrown during the evaluation.
   * @returns {ExceptionDetails=} exceptionDetails Exception details.
   */
  evaluateOnCallFrame() {
    throw new Error('Not implemented');
  }

  /**
   * Compiles expression.
   *
   * @param {string} expression Expression to compile.
   * @param {string} sourceURL Source url to be set for the script.
   * @param {boolean} persistScript Specifies whether the compiled script should be persisted.
   * @param {Runtime.ExecutionContextId=} executionContextId Specifies in which isolated context to perform script run. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
   *
   * @returns {ScriptId=} scriptId Id of the script.
   * @returns {ExceptionDetails=} exceptionDetails Exception details.
   */
  compileScript() {
    throw new Error('Not implemented');
  }

  /**
   * Runs script with given id in a given context.
   *
   * @param {ScriptId} scriptId Id of the script to run.
   * @param {Runtime.ExecutionContextId=} executionContextId Specifies in which isolated context to perform script run. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
   * @param {string=} objectGroup Symbolic group name that can be used to release multiple objects.
   * @param {boolean=} doNotPauseOnExceptionsAndMuteConsole Specifies whether script run should stop on exceptions and mute console. Overrides setPauseOnException state.
   *
   * @returns {Runtime.RemoteObject} result Run result.
   * @returns {ExceptionDetails=} exceptionDetails Exception details.
   */
  runScript() {
    throw new Error('Not implemented');
  }

  /**
   * Changes value of variable in a callframe or a closure.
   * Either callframe or function must be specified.
   * Object-based scopes are not supported and must be mutated manually.
   *
   * @param {integer} scopeNumber 0-based number of scope as was listed in scope chain. Only 'local', 'closure' and 'catch' scope types are allowed. Other scopes could be manipulated manually.
   * @param {string} variableName Variable name.
   * @param {Runtime.CallArgument} newValue New variable value.
   * @param {CallFrameId=} callFrameId Id of callframe that holds variable.
   * @param {Runtime.RemoteObjectId=} functionObjectId Object id of closure (function) that holds variable.
   */
  setVariableValue() {
    throw new Error('Not implemented');
  }

  /**
   * Lists all positions where step-in is possible for a current statement in a specified call frame
   *
   * @param {CallFrameId} callFrameId Id of a call frame where the current statement should be analized
   *
   * @returns {Array.<Location>=} stepInPositions experimental
   */
  getStepInPositions() {
    throw new Error('Not implemented');
  }

  /**
   * Returns call stack including variables changed since VM was paused.
   * VM must be paused.
   *
   * @returns {Array.<CallFrame>} callFrames Call stack the virtual machine stopped on.
   * @returns {StackTrace=} asyncStackTrace Async stack trace, if any.
   */
  getBacktrace() {
    throw new Error('Not implemented');
  }

  /**
   * Makes backend skip steps in the sources with names matching given pattern.
   * VM will try leave blacklisted scripts by performing 'step in' several times, finally resorting to 'step out' if unsuccessful.
   *
   * @param {string=} script Regular expression defining the scripts to ignore while stepping.
   * @param {boolean=} skipContentScripts True, if all content scripts should be ignored.
   */
  skipStackFrames(params) {
    this._ignore('skipStackFrames', params);
  }

  /**
   * Enables or disables async call stacks tracking.
   *
   * @param {integer} maxDepth Maximum depth of async call stacks. Setting to <code>0</code> will effectively disable collecting async call stacks (default).
   */
  setAsyncCallStackDepth(params) {
    this._ignore('setAsyncCallStackDepth', params);
  }

  /**
   * Enables promise tracking, information about <code>Promise</code>s created or updated will now be stored on the backend.
   *
   * @param {boolean=} captureStacks Whether to capture stack traces for promise creation and settlement events (default: false).
   */
  enablePromiseTracker() {
    throw new Error('Not implemented');
  }

  /**
   * Disables promise tracking.
   */
  disablePromiseTracker() {
    throw new Error('Not implemented');
  }

  /**
   * Returns <code>Promise</code> with specified ID.
   *
   * @param {integer} promiseId
   * @param {string=} objectGroup Symbolic group name that can be used to release multiple objects.
   *
   * @returns {Runtime.RemoteObject} promise Object wrapper for <code>Promise</code> with specified ID, if any.
   */
  getPromiseById() {
    throw new Error('Not implemented');
  }

  /**
   * Fires pending <code>asyncOperationStarted</code> events (if any), as if a debugger stepping session has just been started.
   */
  flushAsyncOperationEvents() {
    throw new Error('Not implemented');
  }

  /**
   * Sets breakpoint on AsyncOperation callback handler.
   *
   * @param {integer} operationId ID of the async operation to set breakpoint for.
   */
  setAsyncOperationBreakpoint() {
    throw new Error('Not implemented');
  }

  /**
   * Removes AsyncOperation breakpoint.
   *
   * @param {integer} operationId ID of the async operation to remove breakpoint for.
   */
  removeAsyncOperationBreakpoint() {
    throw new Error('Not implemented');
  }
}

module.exports = DebuggerAgent;
