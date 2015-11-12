'use strict';

const Module = require('module');
const vm = require('vm');

const debug = require('debug')('embedded-agents:debugger');
const _ = require('lodash');

const BaseAgent = require('../base');
const ObjectGroup = require('../object-group');

const UrlMapper = require('../../url-mapper');

const Debug = vm.runInDebugContext('Debug');

const WRAPPER_EXPRESSION = new RegExp([
  '^',
  _.escapeRegExp(Module.wrapper[0]),
  '([\\s\\S]*)',
  _.escapeRegExp(Module.wrapper[1]),
  '$',
].join(''));
function isHostScript(raw) {
  return raw.compilationType() === Debug.ScriptCompilationType.Host;
}
function extractScriptSource(raw) {
  const source = raw.source();
  if (source === undefined || !isHostScript(raw) || raw.name() === 'node.js') {
    return source;
  }
  const matched = source.match(WRAPPER_EXPRESSION);
  if (matched === null) {
    /* eslint no-console: 0 */
    console.error('Warning: script without module wrapper found', raw);
    return source;
  }
  return matched[1];
}

const ScopeTypes = [ 'global', 'local', 'with', 'closure', 'catch', 'block', 'script' ];
function exportFrame(raw) {
  const f = raw.func();
  const sourceLocation = raw.sourceLocation();

  const scopes = raw.allScopes()
    .map(scope => {
      return {
        type: ScopeTypes[scope.scopeType()],
        object: ObjectGroup.add('@break', scope.scopeObject().value()),
      };
    });

  return {
    callFrameId: '' + raw.index(),
    functionName: (f && f.name()) || '(unknown)',
    location: {
      scriptId: sourceLocation && ('' + sourceLocation.script.id),
      lineNumber: sourceLocation && sourceLocation.line,
      columnNumber: sourceLocation && sourceLocation.column,
    },
    scopeChain: scopes,
    this: ObjectGroup.add('@break', raw.receiver().value()),
  };
}

class DebuggerAgent extends BaseAgent {
  constructor() {
    super();
    this._scriptCache = {};
    this._state = null;
  }

  _onAfterCompile(event) {
    this._registerScript(event.script());
  }

  _buildCallStack() {
    const frameCount = this._state.frameCount();
    const frames = new Array(frameCount);
    for (let i = 0; i < frameCount; ++i) {
      frames[i] = exportFrame(this._state.frame(i), i);
    }
    return frames;
  }

  _onBreak(event, state) {
    this._state = state;
    const callFrames = this._buildCallStack();
    this.emit('paused', { callFrames, reason: 'other' });
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
    debug('Found script', raw.name(), script.url || script.scriptId);
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
  setBreakpointByUrl(params) {
    if (params.url) {
      /* script_name, opt_line, opt_column, opt_condition, opt_groupId */
      const breakpointId = Debug.setScriptBreakPointByName(
        UrlMapper.scriptNameFromUrl(params.url),
        params.lineNumber, params.columnNumber,
        params.condition);
      const breakpoint = Debug.findBreakPoint(breakpointId);

      return {
        breakpointId: '' + breakpointId,
        locations: breakpoint.actual_locations()
          .map(location => {
            // [ Object { line: 2, column: 2, script_id: 136 } ]
            return {
              scriptId: '' + location.script_id,
              lineNumber: location.line,
              columnNumber: location.column,
            };
          }),
      };
    }
    this._ignore('setBreakpointByUrl', params);
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
  removeBreakpoint(params) {
    const breakpoint = Debug.findBreakPoint(+params.breakpointId);
    breakpoint.clear();
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
    this._state = null;
    this.emit('resumed');
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
    return { result: true };
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
  setScriptSource(params) {
    const script = _.find(Debug.scripts(), s => s.id === +params.scriptId);
    const scriptSource = params.scriptSource;
    const preview = params.preview;

    const changelog = [];

    /* eslint new-cap: 0 */
    const resultDescription = Debug.LiveEdit.SetScriptSource(
      script, Module.wrap(scriptSource), preview, changelog);

    return {
      stackChanged: resultDescription.stack_modified,
    };
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
    return { scriptSource: extractScriptSource(script) };
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
  compileScript(params) {
    if (params.persistScript) {
      return this._ignore('compileScript', params);
    }
    const expression = Module.wrap(params.expression);
    const filename = params.sourceURL;
    const displayErrors = true;

    try {
      vm.createScript(expression, { filename, displayErrors });
    } catch (error) {
      return {
        exceptionDetails: {
          test: error.message,
        },
      };
    }
    return {};
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
  runScript(params) {
    this._ignore('runScript', params);
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
