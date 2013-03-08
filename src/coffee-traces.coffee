
fs = require 'fs'
coffee = require 'coffee-script-redux'

_sourceMaps = {}

Error.prepareStackTrace = (err, stack) ->
  sourceFiles = {}

  getSourceMapping = (filename, line, column) ->
    mapString = _sourceMaps[filename]
    if mapString
      sourceMap = sourceFiles[filename] ?= mapString
      sourceMap.getSourcePosition [line, column]

  getSourceQuote = ->
    if stack.length > 0 and not stack[0].isNative()
      frame = stack[0]

      if frame.isEval()
        fileName = frame.getScriptNameOrSourceURL()
        fileLocation = "#{frame.getEvalOrigin()}, " unless fileName
      else
        fileName = frame.getFileName()

      return "" unless fileName and fileName[0] is '/'

      line = frame.getLineNumber()
      column = frame.getColumnNumber()

      # Check for a sourceMap position
      source = getSourceMapping fileName, line, column
      if source
        [line, column] = source
        ++line # unfortunately the source map is off

      errorFile = fs.readFileSync(fileName, 'utf8').split("\n")

      color_red = ''
      color_line = ''
      color_reset = ''
      if process.stdout.isTTY
        color_red = '\x1B[0;31m'
        color_line = '\x1B[0;30m'
        color_reset = '\x1B[0m'

      padLineNr = (lineNr) ->
        new Array((line+2).toString().length - lineNr.toString().length + 5).join(' ') + lineNr

      errorLines = for lineNr in [line-2..line+2]
        break unless errorFile[lineNr-1]?
        lineNo = "#{padLineNr lineNr}: "
        if lineNr is line
          "  >#{color_line}#{lineNo.substr(3)}#{color_red}#{errorFile[lineNr-1]}#{color_reset}"
        else
          "#{color_line}#{lineNo}#{color_reset}#{errorFile[lineNr-1]}"

      errorLines.join("\n") + "\n"
    else
      ""

  frames = for frame in stack
    break if frame.getFunction() is exports.runMain
    "  at #{formatSourcePosition frame, getSourceMapping}"

  "#{err.name}: #{err.message ? ''}\n#{frames.shift()}\n#{getSourceQuote()}#{frames.join '\n'}\n"

# Based on http://v8.googlecode.com/svn/branches/bleeding_edge/src/messages.js
# Modified to handle sourceMap
formatSourcePosition = (frame, getSourceMapping) ->
  fileName = undefined
  fileLocation = ''

  if frame.isNative()
    fileLocation = "native"
  else
    if frame.isEval()
      fileName = frame.getScriptNameOrSourceURL()
      fileLocation = "#{frame.getEvalOrigin()}, " unless fileName
    else
      fileName = frame.getFileName()

    fileName or= "<anonymous>"

    line = frame.getLineNumber()
    column = frame.getColumnNumber()

    # Check for a sourceMap position
    source = getSourceMapping fileName, line, column
    fileLocation =
      if source
        "#{fileName}:#{source[0]+1}:#{source[1]}, <js>:#{line}:#{column}"
      else
        "#{fileName}:#{line}:#{column}"

  functionName = frame.getFunctionName()
  isConstructor = frame.isConstructor()
  isMethodCall = not (frame.isToplevel() or isConstructor)

  if isMethodCall
    methodName = frame.getMethodName()
    typeName = frame.getTypeName()

    if functionName
      tp = as = ''
      if typeName and functionName.indexOf typeName
        tp = "#{typeName}."
      if methodName and functionName.indexOf(".#{methodName}") isnt functionName.length - methodName.length - 1
        as = " [as #{methodName}]"

      "#{tp}#{functionName}#{as} (#{fileLocation})"
    else
      "#{typeName}.#{methodName or '<anonymous>'} (#{fileLocation})"
  else if isConstructor
    "new #{functionName or '<anonymous>'} (#{fileLocation})"
  else if functionName
    "#{functionName} (#{fileLocation})"
  else
    fileLocation

compileFile = (filename) ->
  input = fs.readFileSync filename, 'utf8'

  coffeeOptions = optimise: off, bare: on, raw: yes
  csAST = coffee.parse input, coffeeOptions
  jsAST = coffee.compile csAST, coffeeOptions
  {code, map} = coffee.jsWithSourceMap jsAST, filename, coffeeOptions

  console.log code
  # console.log coffee.jsWithSourceMap jsAST, filename, coffeeOptions

  # process.exit 0

  # {js, v3SourceMap, sourceMap} = coffee.compile stripped,
  #   filename: filename
  #   sourceMap: on
  #   header: off
  #   bare: on

  # v3SourceMap = JSON.parse v3SourceMap
  # v3SourceMap.file = filename
  # v3SourceMap.sources = [ filename ]

  _sourceMaps[filename] = map

  code += "\n//@ sourceMappingURL=data:application/json;base64,"
  code += new Buffer("#{map}").toString('base64')
  code += "\n"

compile = (module, filename) ->
  js = compileFile filename
  module._compile js, filename

compileAndBreak = (module, filename) ->
  js = compileFile filename
  js = "console.error('[bugger] Execution stopped at first line');debugger;#{js}"
  module._compile js, filename

if require.extensions
  for ext in ['.coffee']
    require.extensions[ext] = compile

module.exports = {compile, compileAndBreak}
