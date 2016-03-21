'use strict';

const path = require('path');
const Module = require('module');
const vm = require('vm');

const _ = require('lodash');

const BaseAgent = require('../base');
const cliAPI = require('../cli-api');
const ObjectGroup = require('../object-group');

const Debug = vm.runInDebugContext('Debug');

function _createContext() {
  const contextFilename = path.resolve('bugger-repl');
  const context = vm.createContext(Object.create(global));

  context.global = context;
  context.global.global = context;

  const m = context.module = new Module(contextFilename);
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

    this._evalContext = _createContext();
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
    const expression = params.includeCommandLineAPI ?
      `if (typeof __buggerCLI === 'object') {
         with (__buggerCLI) {
           ${params.expression}
         }
       } else {
         ${params.expression}
       }` : params.expression;
    const objectGroup = params.objectGroup;
    const returnByValue = params.returnByValue;
    const displayErrors = params.doNotPauseOnExceptionsAndMuteConsole;

    try {
      const result = this._eval(expression, displayErrors);

      if (returnByValue) {
        throw new Error('Not implemented (returnByValue)');
      }

      if (objectGroup === 'console') {
        cliAPI.setLastEval(result);
      }

      return {
        result: ObjectGroup.add(objectGroup, result, !!params.generatePreview),
        wasThrown: false,
      };
    } catch (error) {
      return ObjectGroup.exportException(params.objectGroup, error);
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
    const value = fn.apply(target.value, args);

    const result = returnByValue ?
      { type: typeof value, value } : ObjectGroup.add(target.objectGroup, value);

    return { result, wasThrown: false };
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
  getProperties(params) {
    if (params.generatePreview) {
      this._ignore('getProperties#generatePreview', params);
    }

    const parsed = ObjectGroup.parseAndGet(params.objectId);
    const ownProperties = params.ownProperties;
    const accessorPropertiesOnly = params.accessorPropertiesOnly;

    let result = [];
    const internalProperties = [];
    const exceptionDetails = undefined;

    function hasAccessor(descriptor) {
      return 'get' in descriptor || 'set' in descriptor;
    }

    function exportProperty(obj, name) {
      if (name in obj) {
        obj[name] = ObjectGroup.add(parsed.objectGroup, obj[name]);
      }
    }

    const seen = Object.create(null);
    function notSeen(key) {
      const hasSeen = key in seen;
      seen[key] = true;
      return !hasSeen;
    }

    function getDescriptor(object, key) {
      const name = key.toString();
      let descriptor = Object.getOwnPropertyDescriptor(object, key);
      if (!descriptor) {
        descriptor = { name, value: object[key], configurable: true, writeable: true };
      }
      descriptor.isOwn = object === parsed.value;
      return _.extend(descriptor, { name });
    }

    function exportPropertyDescriptor(descriptor) {
      exportProperty(descriptor, 'get');
      exportProperty(descriptor, 'set');
      exportProperty(descriptor, 'symbol');
      exportProperty(descriptor, 'value');

      if (!('configurable' in descriptor)) {
        descriptor.configurable = false;
      }

      if (!('enumerable' in descriptor)) {
        descriptor.enumerable = false;
      }

      return descriptor;
    }

    for (let object = parsed.value; object !== null; object = Object.getPrototypeOf(object)) {
      const newProps = [].concat(
          Object.keys(object),
          Object.getOwnPropertyNames(object),
          Object.getOwnPropertySymbols(object)
        )
        .filter(notSeen)
        .map(_.partial(getDescriptor, object))
        .filter(accessorPropertiesOnly ? hasAccessor : _.constant(true))
        .map(exportPropertyDescriptor);
      result = result.concat(newProps);

      if (!accessorPropertiesOnly) {
        /* eslint new-cap: 0 */
        const mirror = Debug.MakeMirror(object);
        mirror.internalProperties().forEach(internal => {
          this._ignore('getProperties#internalProperties', internal);
        });
      }

      if (ownProperties) {
        break;
      }
    }

    return { result, internalProperties, exceptionDetails };
  }

  /**
   * Releases remote object with given id.
   *
   * @param {RemoteObjectId} objectId Identifier of the object to release.
   */
  releaseObject(params) {
    ObjectGroup.releaseObject(params.objectId);
  }

  /**
   * Releases all remote objects that belong to a given group.
   *
   * @param {string} objectGroup Symbolic object group name.
   */
  releaseObjectGroup(params) {
    ObjectGroup.releaseObjectGroup(params.objectGroup);
  }

  /**
   * Tells inspected instance(worker or page) that it can run in case it was started paused.
   */
  run() {
    this._ignore('run');
  }

  _sendExecutionContexts() {
    this.emit('executionContextCreated', {
      context: {
        frameId: 'bugger-frame',
        id: process.pid,
        origin: '',
        name: `${process.mainModule.filename} (${process.pid})`,
      },
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
    return { result: false };
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
