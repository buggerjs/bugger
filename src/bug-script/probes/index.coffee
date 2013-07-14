
knownProbes = ['./coffee', './network']

module.exports = (safe = false) ->
  compilers =
    '.js':
      compile: (filename, code, cb) -> cb(null, { code, map: null })
      compileString: (input) -> input

  scriptContext = { compilers }

  knownProbes.forEach (probeModule) ->
    {load} = require probeModule
    load scriptContext, safe

  scriptContext
