
expect = require 'expect.js'
runBugger = require '../helpers/run_bugger'

describe 'cli launcher', ->
  describe 'hashbang', ->
    it 'can launch a env-based node hashbang', (done) ->
      runBugger [ 'examples/hashbang/node_via_env' ], (err, stdout, stderr) ->
        expect(err).to.be null
        expect(stdout).to.be 'ok\n'
        expect(stderr).to.be ''
        done()

    it 'can launch a env-based coffee hashbang', (done) ->
      runBugger [ 'examples/hashbang/coffee_via_env' ], (err, stdout, stderr) ->
        expect(err).to.be null
        expect(stdout).to.be 'ok\n'
        expect(stderr).to.be ''
        done()

    it 'can launch a weird coffee hashbang with custom parameters', (done) ->
      runBugger [ 'examples/hashbang/coffee_weird' ], (err, stdout, stderr) ->
        expect(err).not.to.be null
        expect(err.code).to.be 42 # we process.exit 42 in that script
        expect(stdout).to.be 'ok\n'
        expect(stderr).to.be ''
        done()
