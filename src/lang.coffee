
path = require 'path'
fs = require 'fs'

patchStackTrace = require './traces'

langExtensions = [ '.coffee' ]
langModules = {}

langExtensions.forEach (ext) ->
  langModule = require "./lang/#{ext.substr(1)}"
  langModules[ext] = langModule

  {compile} = langModule
  # Make it forEach'able
  require.extensions[ext] = compile
  # And seal it so native compilation doesn't overwrite it
  Object.defineProperty require.extensions, ext, get: -> compile

prepareEvaluation = (lang, sourceStr) ->
  if lang in ['js', 'javascript']
    return sourceStr
  return langModules[".#{lang}"].compileString sourceStr

requireScript = (fileName, startPaused) ->
  # Set everything up so it looks like the script was started directly
  mainModule = require.main
  # Set the filename.
  mainModule.filename = process.argv[1] = fs.realpathSync(fileName)
  # Clear the module cache.
  mainModule.moduleCache and= {}
  # Assign paths for node_modules loading
  mainModule.paths = require('module')._nodeModulePaths path.dirname fs.realpathSync(fileName)

  extension = path.extname fileName

  if langModules[extension]?
    {compileAndBreak, compile} = langModules[extension]
    compile = compileAndBreak if startPaused
  else
    compile = (module, filename) ->
      raw = fs.readFileSync filename, 'utf8'
      if startPaused
        raw = "console.error('[bugger] Execution stopped at first line');debugger;\n" + raw
      module._compile raw, filename

  do patchStackTrace
  compile mainModule, fileName

module.exports = {requireScript, prepareEvaluation}
