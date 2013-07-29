
expect = require 'expect.js'
runBugger = require '../helpers/run_bugger'

describe 'network probe', ->
  it 'does not break on missing request callback', (done) ->
    runBugger [ 'examples/request_without_cb.js' ], (err, stdout, stderr) ->
      expect(stderr).to.be ''
      expect(err).to.be null
      expect(stdout).to.be 'ok\n'
      done()
