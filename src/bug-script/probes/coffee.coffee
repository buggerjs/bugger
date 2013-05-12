
coffee = require 'coffee-script-redux'
Module = require 'module'

coffee.register()

compile = (filename, input, cb) ->
  csAst = coffee.parse input, raw: yes
  jsAst = coffee.compile csAst, bare: yes
  {code, map} = coffee.jsWithSourceMap jsAst, filename

  cb null, {code, map}

compileString = (input) ->
  csAst = coffee.parse input, raw: yes
  jsAst = coffee.compile csAst, bare: yes
  coffee.js(jsAst, 'repl', compact: yes)

load = (scriptContext) ->
  scriptContext.compilers['.coffee'] = {compile, compileString}

module.exports = {compile, compileString, load}
