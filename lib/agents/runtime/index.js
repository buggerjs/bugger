'use strict';

const path = require('path');
const Module = require('module');
const vm = require('vm');

const BaseAgent = require('../base');
const ObjectGroup = require('../object-group');

function createContext() {
  var contextFilename = path.resolve('bugger-repl');
  var context = vm.createContext(Object.create(global));

  context.global = context;
  context.global.global = context;

  var m = context.module = new Module(contextFilename);
  m.filename = contextFilename;
  m.paths = Module._nodeModulePaths(contextFilename);

  m._compile('exports.require = require;');
  context.require = m.exports.require;
  context.exports = m.exports = {};

  context.__filename = contextFilename;
  context.__dirname = path.dirname(contextFilename);

  return context;
}

class RuntimeAgent extends BaseAgent {
  constructor() {
    super();

    this._evalContext = createContext();
  }

  _eval(expression, displayErrors) {
    if (expression === 'this') {
      return this._evalContext;
    }
    const script =
      vm.createScript(expression, { filename: '_eval', displayErrors });
    return script.runInContext(this._evalContext, { displayErrors });
  }

  /**
   * Evaluates expression on global object.
   * 
   * @param {string} expression Expression to evaluate.
   * @param {string=} objectGroup Symbolic group name that can be used to release multiple objects.
   * @param {boolean=} includeCommandLineAPI Determines whether Command Line API should be available during the evaluation.
   * @param {boolean=} doNotPauseOnExceptionsAndMuteConsole Specifies whether evaluation should stop on exceptions and mute console. Overrides setPauseOnException state.
   * @param {ExecutionContextId=} contextId Specifies in which isolated context to perform evaluation. Each content script lives in an isolated context and this parameter may be used to specify one of those contexts. If the parameter is omitted or 0 the evaluation will be performed in the context of the inspected page.
   * @param {boolean=} returnByValue Whether the result is expected to be a JSON object that should be sent by value.
   * @param {boolean=} generatePreview Whether preview should be generated for the result.
   * 
   * @returns {RemoteObject} result Evaluation result.
   * @returns {boolean=} wasThrown True if the result was thrown during the evaluation.
   * @returns {Debugger.ExceptionDetails=} exceptionDetails Exception details.
   */
  evaluate(params) {
    const expression = params.expression;
    const objectGroup = params.objectGroup;
    const returnByValue = params.returnByValue;
    const displayErrors = params.doNotPauseOnExceptionsAndMuteConsole;

    try {
      const result = this._eval(expression, displayErrors);

      if (returnByValue) {
        throw new Error('Not implemented (returnByValue)');
      }

      return {
        result: ObjectGroup.add(objectGroup, result),
        wasThrown: false,
      };
    } catch (err) {
      return {
        result: { type: 'string', value: err.message },
        wasThrown: true,
        exceptionDetails: {
          text: err.message,
        },
      };
    }
  }

  /**
   * Calls function with given declaration on the given object.
   * Object group of the result is inherited from the target object.
   * 
   * @param {RemoteObjectId} objectId Identifier of the object to call function on.
   * @param {string} functionDeclaration Declaration of the function to call.
   * @param {Array.<CallArgument>=} arguments Call arguments. All call arguments must belong to the same JavaScript world as the target object.
   * @param {boolean=} doNotPauseOnExceptionsAndMuteConsole Specifies whether function call should stop on exceptions and mute console. Overrides setPauseOnException state.
   * @param {boolean=} returnByValue Whether the result is expected to be a JSON object which should be sent by value.
   * @param {boolean=} generatePreview Whether preview should be generated for the result.
   * 
   * @returns {RemoteObject} result Call result.
   * @returns {boolean=} wasThrown True if the result was thrown during the evaluation.
   */
  callFunctionOn(params) {
    const target = ObjectGroup.parseAndGet(params.objectId);
    const displayErrors = params.doNotPauseOnExceptionsAndMuteConsole;
    const returnByValue = params.returnByValue;

    const fn = this._eval(`(${params.functionDeclaration})`, displayErrors);
    const args = params.arguments.map(ObjectGroup.revive);
    const result = fn.apply(target.value, args);

    if (returnByValue) {
      return {
        result: { type: 'object', value: result },
        wasThrown: false,
      };
    }
    this._ignore('callFunctionOn', params);
  }

  /**
   * Returns properties of a given object.
   * Object group of the result is inherited from the target object.
   * 
   * @param {RemoteObjectId} objectId Identifier of the object to return properties for.
   * @param {boolean=} ownProperties If true, returns properties belonging only to the element itself, not to its prototype chain.
   * @param {boolean=} accessorPropertiesOnly If true, returns accessor properties (with getter/setter) only; internal properties are not returned either.
   * @param {boolean=} generatePreview Whether preview should be generated for the results.
   * 
   * @returns {Array.<PropertyDescriptor>} result Object properties.
   * @returns {Array.<InternalPropertyDescriptor>=} internalProperties Internal object properties (only of the element itself).
   * @returns {Debugger.ExceptionDetails=} exceptionDetails Exception details.
   */
  getProperties() {
    throw new Error('Not implemented');
  }

  /**
   * Releases remote object with given id.
   * 
   * @param {RemoteObjectId} objectId Identifier of the object to release.
   */
  releaseObject() {
    throw new Error('Not implemented');
  }

  /**
   * Releases all remote objects that belong to a given group.
   * 
   * @param {string} objectGroup Symbolic object group name.
   */
  releaseObjectGroup(params) {
    this._ignore('releaseObjectGroup', params);
  }

  /**
   * Tells inspected instance(worker or page) that it can run in case it was started paused.
   */
  run() {
    throw new Error('Not implemented');
  }

  _sendExecutionContexts() {
    this.emit('executionContextCreated', {
      context: {
        frameId: 'bugger-frame',
        id: process.pid,
      }
    });
  }

  /**
   * Enables reporting of execution contexts creation by means of <code>executionContextCreated</code> event.
   * When the reporting gets enabled the event will be sent immediately for each existing execution context.
   */
  enable() {
    this._sendExecutionContexts();
  }

  /**
   * Disables reporting of execution contexts creation.
   */
  disable() {
  }

  /**
   * 
   * @returns {boolean} result True if the Runtime is in paused on start state.
   */
  isRunRequired() {
    throw new Error('Not implemented');
  }

  /**
   * 
   * @param {boolean} enabled
   */
  setCustomObjectFormatterEnabled() {
    throw new Error('Not implemented');
  }
}

module.exports = RuntimeAgent;
