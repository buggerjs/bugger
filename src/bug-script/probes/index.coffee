
knownProbes = ['./coffee', './network', './profiler', './timeline']

module.exports = (safe = false) ->
  compilers =
    '.js':
      compile: (filename, code) -> { code, map: null }
      compileString: (input) -> input

  scriptContext = { compilers }

  knownProbes.forEach (probeModule) ->
    {load} = require probeModule
    load scriptContext, safe

  scriptContext
