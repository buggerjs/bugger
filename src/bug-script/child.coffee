# Hide this script from argv
[__thisFile] = process.argv.splice 1, 1

{realpath, readFile} = require 'fs'
{dirname, extname} = require 'path'
Module = require 'module'
Module._sourceMaps ?= {}
{_nodeModulePaths, _sourceMaps} = Module

compilers =
  '.js':
    compile: (filename, code, cb) -> cb(null, { code, map: null })

    compileString: (input) -> input

  '.coffee': require './compile/coffee'

realpath process.argv[1], (err, filename) ->
  throw err if err?

  # Set everything up so it looks like the script was started directly
  mainModule = require.main
  # Set the filename.
  mainModule.filename = process.argv[1] = filename
  # Clear the module cache.
  mainModule.moduleCache and= {}
  # Assign paths for node_modules loading
  mainModule.paths = _nodeModulePaths dirname mainModule.filename

  # Extract extension
  extension = extname mainModule.filename

  {compile} = compilers[extension] ? compilers['.js']
  prependDebugBreak = process.env.ENABLE_DEBUG_BREAK?

  readFile filename, 'utf8', (err, input) ->
    throw err if err?
    compile mainModule.filename, input, (err, {code, map}) ->
      throw err if err?
      if process.env.ENABLE_DEBUG_BREAK?
        code = "console.error('[bugger] Execution stopped at first line'); debugger; " + code

      if map?
        # Return the compiled javascript
        code += "\n//@ sourceMappingURL=data:application/json;base64,"
        code += new Buffer("#{map}").toString('base64')
        code += "\n"

        _sourceMaps[mainModule.filename] = map

      mainModule._compile code, filename
