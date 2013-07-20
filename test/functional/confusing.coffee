
expect = require 'expect.js'
runBugger = require '../helpers/run_bugger'

describe 'cli launcher', ->
  it 'supports overriding language detection', (done) ->
    runBugger [ '--language=js', 'examples/confusing.coffee' ], (err, stdout, stderr) ->
      expect(stderr).to.be ''
      expect(err).to.be null
      expect(stdout).to.be 'ok\n'
      done()
