
expect = require 'expect.js'

{RemoteObject, ErrorObjectFromMessage} = require '../../../lib/debug-client/remote-object'

knownRawValues =
  nullVar: { body: { handle: 5, type: 'null', text: 'null' }, refs: [] }
  undefinedVar: {"body":{"handle":3,"type":"undefined","text":"undefined"},"refs":[]}
  numberVar: { body: {"handle":25,"type":"number","value":10,"text":"10"}, refs: [] }
  infty: { body: { handle: 23, type: 'number', value: 'Infinity', text: 'Infinity' }, refs: [] }
  nan: { body: { handle: 27, type: 'number', value: 'NaN', text: 'NaN' }, refs: [] }
  boolean: { body: { handle: 17, type: 'boolean', value: false, text: 'false' }, refs: [] }
  str: { body: { handle: 21, type: 'string', value: 'Hello World', length: 11, text: 'Hello World' }, refs: [] }
  longStr:
    body:
      handle: 22
      type: 'string'
      value: 'Donec ullamcorper nulla non metus auctor fringilla. Nullam id dolor id nibh ultr... (length: 945)'
      fromIndex: 0
      toIndex: 80
      length: 945
      text: 'Donec ullamcorper nulla non metus auctor fringilla. Nullam id dolor id nibh ultr... (length: 945)'
    refs: []
  arrayVar: {"body":{"handle":19,"type":"object","className":"Array","constructorFunction":{"ref":71},"protoObject":{"ref":161},"prototypeObject":{"ref":3},"properties":[{"name":"length","attributes":6,"propertyType":3,"ref":162},{"name":0,"ref":156},{"name":1,"ref":146},{"name":2,"ref":162}],"text":"#<Array>"},"refs":[{"handle":71,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":161},"name":"Array","inferredName":"","resolved":true,"source":"function Array() { [native code] }","scopes":[{"type":0,"index":0}],"properties":[{"name":"prototype","attributes":7,"propertyType":3,"ref":161},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"length","attributes":7,"propertyType":3,"ref":156},{"name":"name","attributes":7,"propertyType":3,"ref":356},{"name":"arguments","attributes":7,"propertyType":3,"ref":5},{"name":"isArray","attributes":2,"propertyType":2,"ref":357}],"text":"function Array() { [native code] }"},{"handle":161,"type":"object","className":"Array","constructorFunction":{"ref":71},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"properties":[{"name":"reduce","attributes":2,"propertyType":2,"ref":437},{"name":"toString","attributes":2,"propertyType":2,"ref":438},{"name":"sort","attributes":2,"propertyType":2,"ref":439},{"name":"map","attributes":2,"propertyType":2,"ref":440},{"name":"lastIndexOf","attributes":2,"propertyType":2,"ref":441},{"name":"forEach","attributes":2,"propertyType":2,"ref":442},{"name":"every","attributes":2,"propertyType":2,"ref":443},{"name":"pop","attributes":2,"propertyType":2,"ref":444},{"name":"toLocaleString","attributes":2,"propertyType":2,"ref":445},{"name":"some","attributes":2,"propertyType":2,"ref":446},{"name":"reduceRight","attributes":2,"propertyType":2,"ref":447},{"name":"filter","attributes":2,"propertyType":2,"ref":448},{"name":"push","attributes":2,"propertyType":2,"ref":449},{"name":"length","attributes":6,"propertyType":3,"ref":126},{"name":"unshift","attributes":2,"propertyType":2,"ref":450},{"name":"join","attributes":2,"propertyType":2,"ref":451},{"name":"concat","attributes":2,"propertyType":2,"ref":452},{"name":"indexOf","attributes":2,"propertyType":2,"ref":453},{"name":"shift","attributes":2,"propertyType":2,"ref":454},{"name":"slice","attributes":2,"propertyType":2,"ref":455},{"name":"reverse","attributes":2,"propertyType":2,"ref":456},{"name":"constructor","attributes":2,"propertyType":2,"ref":71},{"name":"splice","attributes":2,"propertyType":2,"ref":457}],"text":"#<Array>"},{"handle":3,"type":"undefined","text":"undefined"},{"handle":162,"type":"number","value":3,"text":"3"},{"handle":156,"type":"number","value":1,"text":"1"},{"handle":146,"type":"number","value":2,"text":"2"}]}
  objVar: {"body":{"handle":20,"type":"object","className":"Object","constructorFunction":{"ref":2},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"properties":[{"name":"foo","propertyType":1,"ref":172}],"text":"#<Object>"},"refs":[{"handle":2,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":4},"name":"Object","inferredName":"","resolved":true,"source":"function Object() { [native code] }","scopes":[],"properties":[{"name":"prototype","attributes":7,"propertyType":3,"ref":4},{"name":"keys","attributes":2,"propertyType":2,"ref":198},{"name":"is","attributes":2,"propertyType":2,"ref":199},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"preventExtensions","attributes":2,"propertyType":2,"ref":200},{"name":"seal","attributes":2,"propertyType":2,"ref":201},{"name":"defineProperties","attributes":2,"propertyType":2,"ref":202},{"name":"getOwnPropertyNames","attributes":2,"propertyType":2,"ref":203},{"name":"isExtensible","attributes":2,"propertyType":2,"ref":204},{"name":"length","attributes":7,"propertyType":3,"ref":156},{"name":"defineProperty","attributes":2,"propertyType":2,"ref":205},{"name":"isSealed","attributes":2,"propertyType":2,"ref":206},{"name":"freeze","attributes":2,"propertyType":2,"ref":207},{"name":"name","attributes":7,"propertyType":3,"ref":208},{"name":"isFrozen","attributes":2,"propertyType":2,"ref":209},{"name":"getPrototypeOf","attributes":2,"propertyType":2,"ref":210},{"name":"create","attributes":2,"propertyType":2,"ref":211},{"name":"getOwnPropertyDescriptor","attributes":2,"propertyType":2,"ref":212},{"name":"arguments","attributes":7,"propertyType":3,"ref":5}],"text":"function Object() { [native code] }"},{"handle":4,"type":"object","className":"Object","constructorFunction":{"ref":2},"protoObject":{"ref":5},"prototypeObject":{"ref":3},"properties":[{"name":"toString","attributes":2,"propertyType":2,"ref":458},{"name":"valueOf","attributes":2,"propertyType":2,"ref":459},{"name":"propertyIsEnumerable","attributes":2,"propertyType":2,"ref":460},{"name":"hasOwnProperty","attributes":2,"propertyType":2,"ref":461},{"name":"__lookupGetter__","attributes":2,"propertyType":2,"ref":462},{"name":"__lookupSetter__","attributes":2,"propertyType":2,"ref":463},{"name":"__defineSetter__","attributes":2,"propertyType":2,"ref":464},{"name":"toLocaleString","attributes":2,"propertyType":2,"ref":465},{"name":"__defineGetter__","attributes":2,"propertyType":2,"ref":466},{"name":"isPrototypeOf","attributes":2,"propertyType":2,"ref":467},{"name":"constructor","attributes":2,"propertyType":2,"ref":2}],"text":"#<Object>"},{"handle":3,"type":"undefined","text":"undefined"},{"handle":172,"type":"string","value":"bar","length":3,"text":"bar"}]}
  rootObj: {"body":{"handle":0,"type":"object","className":"global","constructorFunction":{"ref":1},"protoObject":{"ref":2},"prototypeObject":{"ref":3},"properties":[],"text":"#<Object>"},"refs":[{"handle":1,"type":"function","className":"Function","constructorFunction":{"ref":4},"protoObject":{"ref":5},"prototypeObject":{"ref":6},"name":"Object","inferredName":"","resolved":true,"source":"function Object() { [native code] }","scopes":[],"properties":[{"name":"length","attributes":7,"propertyType":3,"ref":7},{"name":"name","attributes":7,"propertyType":3,"ref":8},{"name":"arguments","attributes":7,"propertyType":3,"ref":9},{"name":"caller","attributes":7,"propertyType":3,"ref":9},{"name":"prototype","attributes":7,"propertyType":3,"ref":6},{"name":"keys","attributes":2,"propertyType":2,"ref":10},{"name":"create","attributes":2,"propertyType":2,"ref":11},{"name":"defineProperty","attributes":2,"propertyType":2,"ref":12},{"name":"defineProperties","attributes":2,"propertyType":2,"ref":13},{"name":"freeze","attributes":2,"propertyType":2,"ref":14},{"name":"getPrototypeOf","attributes":2,"propertyType":2,"ref":15},{"name":"getOwnPropertyDescriptor","attributes":2,"propertyType":2,"ref":16},{"name":"getOwnPropertyNames","attributes":2,"propertyType":2,"ref":17},{"name":"is","attributes":2,"propertyType":2,"ref":18},{"name":"isExtensible","attributes":2,"propertyType":2,"ref":19},{"name":"isFrozen","attributes":2,"propertyType":2,"ref":20},{"name":"isSealed","attributes":2,"propertyType":2,"ref":21},{"name":"preventExtensions","attributes":2,"propertyType":2,"ref":22},{"name":"seal","attributes":2,"propertyType":2,"ref":23}],"text":"function Object() { [native code] }"},{"handle":2,"type":"object","className":"Object","constructorFunction":{"ref":1},"protoObject":{"ref":6},"prototypeObject":{"ref":3},"properties":[{"name":"constructor","attributes":2,"propertyType":1,"ref":1}],"text":"#<Object>"},{"handle":3,"type":"undefined","text":"undefined"}]}
  objectByValue: {"body":{"handle":0,"type":"object","className":"Object","constructorFunction":{"ref":1},"protoObject":{"ref":2},"prototypeObject":{"ref":3},"properties":[{"name":"setTimeout","ref":1},{"name":"DTRACE_NET_SOCKET_READ","ref":1},{"name":"RegExp","ref":1},{"name":"Int16Array","ref":1},{"name":"root","ref":1},{"name":"Int32Array","ref":1},{"name":"TypeError","ref":1},{"name":"toString","ref":1},{"name":"GLOBAL","ref":1},{"name":"clearImmediate","ref":1},{"name":"cache$1","ref":1},{"name":"process","ref":1},{"name":"escape","ref":1},{"name":"clearTimeout","ref":1},{"name":"console","ref":1},{"name":"DTRACE_NET_STREAM_END","ref":1},{"name":"cache$2","ref":1},{"name":"valueOf","ref":1},{"name":"JSON","ref":1},{"name":"__defineSetter__","ref":1},{"name":"__lookupGetter__","ref":1},{"name":"RangeError","ref":1},{"name":"encodeURI","ref":1},{"name":"constructor","ref":1},{"name":"Float32Array","ref":1},{"name":"toLocaleString","ref":1},{"name":"SyntaxError","ref":1},{"name":"unescape","ref":1},{"name":"Number","ref":1},{"name":"cache$","ref":1},{"name":"propertyIsEnumerable","ref":1},{"name":"Uint32Array","ref":1},{"name":"DTRACE_NET_SERVER_CONNECTION","ref":1},{"name":"Buffer","ref":1},{"name":"setImmediate","ref":1},{"name":"String","ref":1},{"name":"DTRACE_HTTP_CLIENT_REQUEST","ref":1},{"name":"URIError","ref":1},{"name":"Uint8Array","ref":1},{"name":"DTRACE_HTTP_SERVER_RESPONSE","ref":1},{"name":"setInterval","ref":1},{"name":"isPrototypeOf","ref":1},{"name":"Error","ref":1},{"name":"encodeURIComponent","ref":1},{"name":"isNaN","ref":1},{"name":"Int8Array","ref":1},{"name":"isFinite","ref":1},{"name":"global","ref":1},{"name":"Object","ref":1},{"name":"Uint8ClampedArray","ref":1},{"name":"DTRACE_NET_SOCKET_WRITE","ref":1},{"name":"DTRACE_HTTP_SERVER_REQUEST","ref":1},{"name":"ArrayBuffer","ref":1},{"name":"parseInt","ref":1},{"name":"DTRACE_HTTP_CLIENT_RESPONSE","ref":1},{"name":"Infinity","ref":1},{"name":"parseFloat","ref":1},{"name":"decodeURIComponent","ref":1},{"name":"undefined","ref":1},{"name":"ReferenceError","ref":1},{"name":"Uint16Array","ref":1},{"name":"hasOwnProperty","ref":1},{"name":"Float64Array","ref":1},{"name":"Date","ref":1},{"name":"Math","ref":1},{"name":"EvalError","ref":1},{"name":"Boolean","ref":1},{"name":"clearInterval","ref":1},{"name":"decodeURI","ref":1},{"name":"Array","ref":1},{"name":"DataView","ref":1},{"name":"__defineGetter__","ref":1},{"name":"__lookupSetter__","ref":1},{"name":"NaN","ref":1},{"name":"eval","ref":1},{"name":"Function","ref":1}],"text":"#<Object>"},"refs":[{"handle":1,"type":"boolean","value":true,"text":"true"},{"handle":2,"type":"object","className":"Object","constructorFunction":{"ref":4},"protoObject":{"ref":5},"prototypeObject":{"ref":3},"properties":[{"name":"constructor","attributes":2,"propertyType":2,"ref":4},{"name":"toString","attributes":2,"propertyType":2,"ref":6},{"name":"toLocaleString","attributes":2,"propertyType":2,"ref":7},{"name":"valueOf","attributes":2,"propertyType":2,"ref":8},{"name":"hasOwnProperty","attributes":2,"propertyType":2,"ref":9},{"name":"isPrototypeOf","attributes":2,"propertyType":2,"ref":10},{"name":"propertyIsEnumerable","attributes":2,"propertyType":2,"ref":11},{"name":"__defineGetter__","attributes":2,"propertyType":2,"ref":12},{"name":"__lookupGetter__","attributes":2,"propertyType":2,"ref":13},{"name":"__defineSetter__","attributes":2,"propertyType":2,"ref":14},{"name":"__lookupSetter__","attributes":2,"propertyType":2,"ref":15}],"text":"#<Object>"},{"handle":3,"type":"undefined","text":"undefined"}]}
  regexVar:
    body:
      handle: 24
      type: "regexp"
      className: "RegExp"
      constructorFunction: { "ref": 81 }
      protoObject: { "ref": 173 }
      prototypeObject: { "ref": 3 }
      properties: [
        {"name":"lastIndex","attributes":6,"propertyType":1,"ref":126},
        {"name":"source","attributes":7,"propertyType":1,"ref":174},
        {"name":"ignoreCase","attributes":7,"propertyType":1,"ref":17},
        {"name":"multiline","attributes":7,"propertyType":1,"ref":17},
        {"name":"global","attributes":7,"propertyType":1,"ref":175}
      ]
      text: "/^foo$/"
    refs: [
      {
        "handle": 81
        "type": "function"
        "className": "Function"
        "constructorFunction": { "ref": 52 }
        "protoObject": { "ref": 163 }
        "prototypeObject": { "ref": 173 }
        "name": "RegExp"
        "inferredName": ""
        "resolved": true
        "source": "function RegExp() { [native code] }"
        "scopes": []
        "properties":[
          {"name":"rightContext","attributes":4,"propertyType":3,"ref":3},
          {"name":"$&","attributes":6,"propertyType":3,"ref":3},
          {"name":"$4","attributes":4,"propertyType":3,"ref":3},
          {"name":"prototype","attributes":7,"propertyType":3,"ref":173},
          {"name":"$8","attributes":4,"propertyType":3,"ref":3},
          {"name":"caller","attributes":7,"propertyType":3,"ref":5},
          {"name":"lastMatch","attributes":4,"propertyType":3,"ref":3},
          {"name":"$*","attributes":6,"propertyType":3,"ref":3},
          {"name":"lastParen","attributes":4,"propertyType":3,"ref":3},
          {"name":"$1","attributes":4,"propertyType":3,"ref":3},
          {"name":"$`","attributes":6,"propertyType":3,"ref":3},
          {"name":"$'","attributes":6,"propertyType":3,"ref":3},
          {"name":"$5","attributes":4,"propertyType":3,"ref":3},
          {"name":"$2","attributes":4,"propertyType":3,"ref":3},
          {"name":"$9","attributes":4,"propertyType":3,"ref":3},
          {"name":"$6","attributes":4,"propertyType":3,"ref":3},
          {"name":"$_","attributes":6,"propertyType":3,"ref":3},
          {"name":"leftContext","attributes":4,"propertyType":3,"ref":3},
          {"name":"$+","attributes":6,"propertyType":3,"ref":3},
          {"name":"multiline","attributes":4,"propertyType":3,"ref":3},
          {"name":"length","attributes":7,"propertyType":3,"ref":146},
          {"name":"$3","attributes":4,"propertyType":3,"ref":3},
          {"name":"$7","attributes":4,"propertyType":3,"ref":3},
          {"name":"$input","attributes":6,"propertyType":3,"ref":3},
          {"name":"input","attributes":4,"propertyType":3,"ref":3},
          {"name":"name","attributes":7,"propertyType":3,"ref":407},
          {"name":"arguments","attributes":7,"propertyType":3,"ref":5}
        ]
        "text":"function RegExp() { [native code] }"
      },
      {"handle":173,"type":"regexp","className":"RegExp","constructorFunction":{"ref":81},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"properties":[{"name":"lastIndex","attributes":6,"propertyType":1,"ref":126},{"name":"source","attributes":7,"propertyType":1,"ref":468},{"name":"test","attributes":2,"propertyType":2,"ref":469},{"name":"toString","attributes":2,"propertyType":2,"ref":470},{"name":"ignoreCase","attributes":7,"propertyType":1,"ref":17},{"name":"compile","attributes":2,"propertyType":2,"ref":471},{"name":"exec","attributes":2,"propertyType":2,"ref":472},{"name":"multiline","attributes":7,"propertyType":1,"ref":17},{"name":"global","attributes":7,"propertyType":1,"ref":17},{"name":"constructor","attributes":2,"propertyType":2,"ref":81}],"text":"/(?:)/"},
      {"handle":3,"type":"undefined","text":"undefined"},
      {"handle":126,"type":"number","value":0,"text":"0"},
      {"handle":174,"type":"string","value":"^foo$","length":5,"text":"^foo$"},
      {"handle":17,"type":"boolean","value":false,"text":"false"},
      {"handle":175,"type":"boolean","value":true,"text":"true"}
    ]
  dateVar: {"body":{"handle":15,"type":"object","className":"Date","constructorFunction":{"ref":75},"protoObject":{"ref":158},"prototypeObject":{"ref":3},"value":"2013-05-19T18:21:32.964Z","properties":[],"text":"2013-05-19T18:21:32.964Z"},"refs":[{"handle":75,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":158},"name":"Date","inferredName":"","resolved":true,"source":"function Date() { [native code] }","scopes":[],"properties":[{"name":"prototype","attributes":7,"propertyType":3,"ref":158},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"parse","attributes":2,"propertyType":2,"ref":384},{"name":"now","attributes":2,"propertyType":2,"ref":387},{"name":"length","attributes":7,"propertyType":3,"ref":388},{"name":"name","attributes":7,"propertyType":3,"ref":389},{"name":"arguments","attributes":7,"propertyType":3,"ref":5},{"name":"UTC","attributes":2,"propertyType":2,"ref":390}],"text":"function Date() { [native code] }"},{"handle":158,"type":"object","className":"Date","constructorFunction":{"ref":75},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"value":null,"properties":[{"name":"getMilliseconds","attributes":2,"propertyType":2,"ref":473},{"name":"setSeconds","attributes":2,"propertyType":2,"ref":474},{"name":"setHours","attributes":2,"propertyType":2,"ref":475},{"name":"toLocaleDateString","attributes":2,"propertyType":2,"ref":476},{"name":"toString","attributes":2,"propertyType":2,"ref":477},{"name":"getUTCMonth","attributes":2,"propertyType":2,"ref":478},{"name":"setUTCMinutes","attributes":2,"propertyType":2,"ref":479},{"name":"getTime","attributes":2,"propertyType":2,"ref":480},{"name":"valueOf","attributes":2,"propertyType":2,"ref":481},{"name":"getHours","attributes":2,"propertyType":2,"ref":482},{"name":"getUTCFullYear","attributes":2,"propertyType":2,"ref":483},{"name":"getUTCMilliseconds","attributes":2,"propertyType":2,"ref":484},{"name":"setTime","attributes":2,"propertyType":2,"ref":485},{"name":"setUTCDate","attributes":2,"propertyType":2,"ref":486},{"name":"getUTCSeconds","attributes":2,"propertyType":2,"ref":487},{"name":"getSeconds","attributes":2,"propertyType":2,"ref":488},{"name":"toISOString","attributes":2,"propertyType":2,"ref":489},{"name":"getDate","attributes":2,"propertyType":2,"ref":490},{"name":"setUTCSeconds","attributes":2,"propertyType":2,"ref":491},{"name":"getDay","attributes":2,"propertyType":2,"ref":492},{"name":"toLocaleString","attributes":2,"propertyType":2,"ref":493},{"name":"getMinutes","attributes":2,"propertyType":2,"ref":494},{"name":"toLocaleTimeString","attributes":2,"propertyType":2,"ref":495},{"name":"toTimeString","attributes":2,"propertyType":2,"ref":496},{"name":"getMonth","attributes":2,"propertyType":2,"ref":497},{"name":"getUTCDay","attributes":2,"propertyType":2,"ref":498},{"name":"setFullYear","attributes":2,"propertyType":2,"ref":499},{"name":"getTimezoneOffset","attributes":2,"propertyType":2,"ref":500},{"name":"setYear","attributes":2,"propertyType":2,"ref":501},{"name":"setMinutes","attributes":2,"propertyType":2,"ref":502},{"name":"setUTCMilliseconds","attributes":2,"propertyType":2,"ref":503},{"name":"getYear","attributes":2,"propertyType":2,"ref":504},{"name":"getUTCHours","attributes":2,"propertyType":2,"ref":505},{"name":"toJSON","attributes":2,"propertyType":2,"ref":506},{"name":"setUTCMonth","attributes":2,"propertyType":2,"ref":507},{"name":"toGMTString","attributes":2,"propertyType":2,"ref":508},{"name":"setMonth","attributes":2,"propertyType":2,"ref":509},{"name":"getUTCMinutes","attributes":2,"propertyType":2,"ref":510},{"name":"setUTCFullYear","attributes":2,"propertyType":2,"ref":511},{"name":"toDateString","attributes":2,"propertyType":2,"ref":512},{"name":"getFullYear","attributes":2,"propertyType":2,"ref":513},{"name":"constructor","attributes":2,"propertyType":2,"ref":75},{"name":"toUTCString","attributes":2,"propertyType":2,"ref":514},{"name":"setDate","attributes":2,"propertyType":2,"ref":515},{"name":"setMilliseconds","attributes":2,"propertyType":2,"ref":516},{"name":"setUTCHours","attributes":2,"propertyType":2,"ref":517},{"name":"getUTCDate","attributes":2,"propertyType":2,"ref":518}],"text":"ul"},{"handle":3,"type":"undefined","text":"undefined"}]}
  functionVar: {"body":{"handle":26,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":159},"name":"functionVar","inferredName":"","resolved":true,"source":"function functionVar() {\n  this.member = 42;\n}","script":{"ref":12},"scriptId":57,"position":1413,"line":19,"column":20,"scopes":[{"type":0,"index":0}],"properties":[{"name":"prototype","attributes":6,"propertyType":3,"ref":159},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"length","attributes":7,"propertyType":3,"ref":126},{"name":"name","attributes":7,"propertyType":3,"ref":179},{"name":"arguments","attributes":7,"propertyType":3,"ref":5}],"text":"function functionVar() {\n  this.member = 42;\n}"},"refs":[{"handle":52,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":163},"name":"Function","inferredName":"","resolved":true,"source":"function Function() { [native code] }","scopes":[],"properties":[{"name":"prototype","attributes":7,"propertyType":3,"ref":163},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"length","attributes":7,"propertyType":3,"ref":156},{"name":"name","attributes":7,"propertyType":3,"ref":190},{"name":"arguments","attributes":7,"propertyType":3,"ref":5}],"text":"function Function() { [native code] }"},{"handle":163,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"name":"Empty","inferredName":"","resolved":true,"source":"function Empty() {}","script":{"ref":165},"scriptId":1,"position":0,"line":0,"column":0,"scopes":[{"type":0,"index":0}],"properties":[{"name":"toString","attributes":2,"propertyType":2,"ref":519},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"bind","attributes":2,"propertyType":2,"ref":520},{"name":"call","attributes":2,"propertyType":2,"ref":521},{"name":"apply","attributes":2,"propertyType":2,"ref":522},{"name":"length","attributes":7,"propertyType":3,"ref":126},{"name":"name","attributes":7,"propertyType":3,"ref":523},{"name":"arguments","attributes":7,"propertyType":3,"ref":5},{"name":"constructor","attributes":2,"propertyType":2,"ref":52}],"text":"function Empty() {}"},{"handle":159,"type":"object","className":"Object","constructorFunction":{"ref":26},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"properties":[{"name":"someFun","propertyType":2,"ref":524},{"name":"constructor","attributes":2,"propertyType":2,"ref":26}],"text":"#<functionVar>"},{"handle":12,"type":"script","name":"/Users/jankrems/Projects/bugger/examples/types.js","id":57,"lineOffset":0,"columnOffset":0,"lineCount":28,"sourceStart":"(function (exports, require, module, __filename, __dirname) { debugger; \nvar nul","sourceLength":1611,"scriptType":2,"compilationType":0,"context":{"ref":11},"text":"/Users/jankrems/Projects/bugger/examples/types.js (lines: 28)"},{"handle":5,"type":"null","text":"null"},{"handle":126,"type":"number","value":0,"text":"0"},{"handle":179,"type":"string","value":"functionVar","length":11,"text":"functionVar"}]}
  instance: {"body":{"handle":18,"type":"object","className":"Object","constructorFunction":{"ref":26},"protoObject":{"ref":159},"prototypeObject":{"ref":3},"properties":[{"name":"member","propertyType":1,"ref":160}],"text":"#<functionVar>"},"refs":[{"handle":26,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":159},"name":"functionVar","inferredName":"","resolved":true,"source":"function functionVar() {\n  this.member = 42;\n}","script":{"ref":12},"scriptId":57,"position":1413,"line":19,"column":20,"scopes":[{"type":0,"index":0}],"properties":[{"name":"prototype","attributes":6,"propertyType":3,"ref":159},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"length","attributes":7,"propertyType":3,"ref":126},{"name":"name","attributes":7,"propertyType":3,"ref":179},{"name":"arguments","attributes":7,"propertyType":3,"ref":5}],"text":"function functionVar() {\n  this.member = 42;\n}"},{"handle":159,"type":"object","className":"Object","constructorFunction":{"ref":26},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"properties":[{"name":"someFun","propertyType":2,"ref":524},{"name":"constructor","attributes":2,"propertyType":2,"ref":26}],"text":"#<functionVar>"},{"handle":3,"type":"undefined","text":"undefined"},{"handle":160,"type":"number","value":42,"text":"42"}]}
  reffed: {"body":{"ref":71},"refs":[{"handle":71,"type":"function","className":"Function","constructorFunction":{"ref":52},"protoObject":{"ref":163},"prototypeObject":{"ref":161},"name":"Array","inferredName":"","resolved":true,"source":"function Array() { [native code] }","scopes":[{"type":0,"index":0}],"properties":[{"name":"prototype","attributes":7,"propertyType":3,"ref":161},{"name":"caller","attributes":7,"propertyType":3,"ref":5},{"name":"length","attributes":7,"propertyType":3,"ref":156},{"name":"name","attributes":7,"propertyType":3,"ref":356},{"name":"arguments","attributes":7,"propertyType":3,"ref":5},{"name":"isArray","attributes":2,"propertyType":2,"ref":357}],"text":"function Array() { [native code] }"},{"handle":161,"type":"object","className":"Array","constructorFunction":{"ref":71},"protoObject":{"ref":4},"prototypeObject":{"ref":3},"properties":[{"name":"reduce","attributes":2,"propertyType":2,"ref":437},{"name":"toString","attributes":2,"propertyType":2,"ref":438},{"name":"sort","attributes":2,"propertyType":2,"ref":439},{"name":"map","attributes":2,"propertyType":2,"ref":440},{"name":"lastIndexOf","attributes":2,"propertyType":2,"ref":441},{"name":"forEach","attributes":2,"propertyType":2,"ref":442},{"name":"every","attributes":2,"propertyType":2,"ref":443},{"name":"pop","attributes":2,"propertyType":2,"ref":444},{"name":"toLocaleString","attributes":2,"propertyType":2,"ref":445},{"name":"some","attributes":2,"propertyType":2,"ref":446},{"name":"reduceRight","attributes":2,"propertyType":2,"ref":447},{"name":"filter","attributes":2,"propertyType":2,"ref":448},{"name":"push","attributes":2,"propertyType":2,"ref":449},{"name":"length","attributes":6,"propertyType":3,"ref":126},{"name":"unshift","attributes":2,"propertyType":2,"ref":450},{"name":"join","attributes":2,"propertyType":2,"ref":451},{"name":"concat","attributes":2,"propertyType":2,"ref":452},{"name":"indexOf","attributes":2,"propertyType":2,"ref":453},{"name":"shift","attributes":2,"propertyType":2,"ref":454},{"name":"slice","attributes":2,"propertyType":2,"ref":455},{"name":"reverse","attributes":2,"propertyType":2,"ref":456},{"name":"constructor","attributes":2,"propertyType":2,"ref":71},{"name":"splice","attributes":2,"propertyType":2,"ref":457}],"text":"#<Array>"},{"handle":3,"type":"undefined","text":"undefined"},{"handle":162,"type":"number","value":3,"text":"3"},{"handle":156,"type":"number","value":1,"text":"1"},{"handle":146,"type":"number","value":2,"text":"2"}]}

DEFAULT_OPTIONS = {returnByValue: false, generatePreview: false}
WITH_PREVIEW = {returnByValue: false, generatePreview: true}
WITH_VALUE = {returnByValue: true, generatePreview: false}

withRawValue = (name, options, cb) ->
  describe "#{name} #{JSON.stringify options}", ->
    {body, refs} = knownRawValues[name]

    refMap = {}
    if Array.isArray refs
      refMap[ref.handle.toString()] = ref for ref in refs

    mapped = RemoteObject(options)(refMap)(body)
    cb mapped

describe 'debug-client', ->
  describe 'RemoteObject', ->
    withRawValue 'nullVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has subtype null', -> expect(mapped.subtype).to.be 'null'

    withRawValue 'undefinedVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type undefined', -> expect(mapped.type).to.be 'undefined'
      it 'has value undefined', -> expect(mapped.value).to.be undefined

    withRawValue 'numberVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type number', -> expect(mapped.type).to.be 'number'
      it 'has description "10"', -> expect(mapped.description).to.be '10'

    withRawValue 'infty', DEFAULT_OPTIONS, (mapped) ->
      it 'has type number', -> expect(mapped.type).to.be 'number'
      it 'has description Infinity', -> expect(mapped.description).to.be 'Infinity'

    withRawValue 'nan', DEFAULT_OPTIONS, (mapped) ->
      it 'has type number', -> expect(mapped.type).to.be 'number'
      it 'has no object id', -> expect(mapped.objectId).to.be undefined
      it 'has description NaN', -> expect(mapped.description).to.be 'NaN'

    withRawValue 'str', DEFAULT_OPTIONS, (mapped) ->
      it 'has type string', -> expect(mapped.type).to.be 'string'

    withRawValue 'longStr', DEFAULT_OPTIONS, (mapped) ->
      it 'has type string', -> expect(mapped.type).to.be 'string'

    withRawValue 'arrayVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has subtype array', -> expect(mapped.subtype).to.be 'array'

    withRawValue 'objVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has a string object id', -> expect(typeof mapped.objectId).to.be 'string'
      it 'has a object id "20"', -> expect(mapped.objectId).to.be '20'
      it 'has className "Object"', -> expect(mapped.className).to.be 'Object'

    withRawValue 'objVar', WITH_PREVIEW, (mapped) ->
      it 'has a preview', -> expect(mapped.preview).not.be.eql null

    withRawValue 'rootObj', WITH_PREVIEW, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has a string object id', -> expect(typeof mapped.objectId).to.be 'string'
      it 'has a object id "0"', -> expect(mapped.objectId).to.be '0'
      it 'has className "Object"', -> expect(mapped.className).to.be 'Object'

    withRawValue 'objectByValue', WITH_VALUE, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has a string object id', -> expect(typeof mapped.objectId).to.be 'string'
      it 'has a object id "0"', -> expect(mapped.objectId).to.be '0'
      it 'has a property map', -> expect(mapped.value).to.be.an 'object'
      it 'has 76 properties', -> expect(Object.keys(mapped.value).length).to.be 76
      it 'has only properties with value true', ->
        for k, v of mapped.value
          expect(v).to.be true

    withRawValue 'regexVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has subtype regexp', -> expect(mapped.subtype).to.be 'regexp'
      it 'has className "RegExp"', -> expect(mapped.className).to.be 'RegExp'

    withRawValue 'dateVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has subtype date', -> expect(mapped.subtype).to.be 'date'
      it 'has className "Date"', -> expect(mapped.className).to.be 'Date'

    withRawValue 'functionVar', DEFAULT_OPTIONS, (mapped) ->
      it 'has type function', -> expect(mapped.type).to.be 'function'
      it 'has className "Function"', -> expect(mapped.className).to.be 'Function'

    withRawValue 'instance', DEFAULT_OPTIONS, (mapped) ->
      it 'has type object', -> expect(mapped.type).to.be 'object'
      it 'has className "functionVar"', -> expect(mapped.className).to.be 'functionVar'

    withRawValue 'reffed', DEFAULT_OPTIONS, (mapped) ->
      it 'has type function', -> expect(mapped.type).to.be 'function'
