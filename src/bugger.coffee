
path = require 'path'
fs = require 'fs'

# Extension that will automatically be added to a filename if omitted
knownExtensions = [ '.js', '.coffee' ]

resolveModule = (fileName) ->
  # Rules:
  # - if it's a relative path, convert to absolute
  # - if it's an unknown file extension, try with extention first
  # - if the file exists, use the file
  # - if it's a directory, look for index inside
  if fileName[0] isnt '/'
    resolveModule path.join(process.cwd(), fileName)
  else
    fileName = path.normalize fileName
    unless path.extname(fileName) in knownExtensions
      for ext in knownExtensions
        withExtension = resolveModule fileName + ext
        return withExtension if withExtension?
    try
      fileStat = fs.statSync fileName
      if fileStat.isDirectory()
        return resolveModule path.join(fileName, 'index')
      else
        return fileName
    catch err
      throw err unless err.code is 'ENOENT'
      return null

requireScript = (fileName, startPaused) ->
  # Set everything up so it looks like the script was started directly
  mainModule = require.main
  # Set the filename.
  mainModule.filename = process.argv[1] = fs.realpathSync(fileName)
  # Clear the module cache.
  mainModule.moduleCache and= {}
  # Assign paths for node_modules loading
  mainModule.paths = require('module')._nodeModulePaths path.dirname fs.realpathSync(fileName)

  {compileAndBreak, compile, patchStackTrace} = require('./coffee-traces')

  compile = if path.extname(fileName) is '.coffee'
    if startPaused then compileAndBreak
    else compile
  else
    (module, filename) ->
      raw = fs.readFileSync filename, 'utf8'
      if startPaused
        raw = "console.error('[bugger] Execution stopped at first line');debugger;\n" + raw
      module._compile raw, filename

  do patchStackTrace
  compile mainModule, fileName

module.exports = {resolveModule, requireScript}
