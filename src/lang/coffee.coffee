
fs = require 'fs'
coffee = require 'coffee-script-redux'
Module = require 'module'

compileFile = (filename) ->
  input = fs.readFileSync filename, 'utf8'
  csAst = coffee.parse input, raw: yes
  jsAst = coffee.compile csAst
  {code, map} = coffee.jsWithSourceMap jsAst, filename

  # Make the source map available on request
  Module._sourceMaps[filename] = -> "#{map}"

  # Return the compiled javascript
  code += "\n//@ sourceMappingURL=data:application/json;base64,"
  code += new Buffer("#{map}").toString('base64')
  code += "\n"

compile = (module, filename) ->
  js = compileFile filename
  module._compile js, filename

compileString = (input) ->
  csAst = coffee.parse input, raw: yes
  jsAst = coffee.compile csAst
  coffee.js jsAst, compact: yes

compileAndBreak = (module, filename) ->
  js = compileFile filename
  js = "console.log('[bugger] Halting execution on first line.'); debugger; #{js}"
  module._compile js, filename

module.exports = {compile, compileAndBreak, compileString}
