
###
{ type: 'frame',
  index: 1,
  receiver: { ref: 7, type: 'object', className: 'Object' },
  func: 
   { ref: 93,
     type: 'function',
     name: '',
     inferredName: 'Module._compile',
     scriptId: 28 },
  script: { ref: 44 },
  constructCall: false,
  atReturn: false,
  debuggerFrame: false,
  arguments: 
   [ { name: 'content', value: [Object] },
     { name: 'filename', value: [Object] } ],
  locals: 
   [ { name: 'k', value: [Object] },
     { name: 'sandbox', value: [Object] },
     { name: 'wrapper', value: [Object] },
     { name: 'compiledWrapper', value: [Object] },
     { name: 'args', value: [Object] },
     { name: 'dirname', value: [Object] },
     { name: 'require', value: [Object] },
     { name: 'self', value: [Object] } ],
  position: 12609,
  line: 448,
  column: 25,
  sourceLineText: '  return compiledWrapper.apply(self.exports, args);',
  scopes: 
   [ { type: 1, index: 0 },
     { type: 3, index: 1 },
     { type: 0, index: 2 } ],
  text: '#01 #<Module>._compile(content=console.error(\'[bugger] Execution stopped at first line\'); debugger; console.log... (length: 131), filename=/Users/jankrems/Projects/bugger/examples/simple.js) module.js line 449 column 26 (position 12610)' }
###

###
Debugger.CallFrame = {"id":"CallFrame","type":"object","properties":[
  {"name":"callFrameId","$ref":"CallFrameId","description":"Call frame identifier. This identifier is only valid while the virtual machine is paused."},
  {"name":"functionName","type":"string","description":"Name of the JavaScript function called on this call frame."},
  {"name":"location","$ref":"Location","description":"Location in the source code."},
  {"name":"scopeChain","type":"array","items":{"$ref":"Scope"},"description":"Scope chain for this call frame."},
  {"name":"this","$ref":"Runtime.RemoteObject","description":"<code>this</code> object for this call frame."}],
  "description":"JavaScript call frame. Array of call frames form the call stack."}

Debugger.Location = {"id":"Location","type":"object","properties":[
  {"name":"scriptId","$ref":"ScriptId","description":"Script identifier as reported in the <code>Debugger.scriptParsed</code>."},
  {"name":"lineNumber","type":"integer","description":"Line number in the script."},
  {"name":"columnNumber","type":"integer","optional":true,"description":"Column number in the script."}],
  "description":"Location in the source code."}
###

functionName = (func) ->
  if !!func.name
    func.name
  else
    func.inferredName

module.exports = (refs) -> (body) ->
  {
    callFrameId: body.index.toString()
    functionName: functionName body.func
    location:
      scriptId: body.func.scriptId.toString()
      lineNumber: body.line
      columnNumber: body.column
    scopeChain: body.scopes.map (scope) ->
      refs["scope:#{body.index}:#{scope.index}"]
  }
