
expect = require 'expect.js'
runBugger = require '../helpers/run_bugger'

checkHelloWorld = (lang, done) -> (err, stdout, stderr) ->
  expect(err).to.be null
  expect(stdout).to.be "[simple.#{lang}] Log to stdout\n"
  expect(stderr).to.be "[simple.#{lang}] Log to stderr\n"
  done()

describe 'cli launcher', ->
  describe 'simple', ->
    it 'can launch examples/simple.coffee', (done) ->
      runBugger [ 'examples/simple.coffee' ], checkHelloWorld('coffee', done)

    it 'can launch examples/simple.js', (done) ->
      runBugger [ 'examples/simple.js' ], checkHelloWorld('js', done)

    it 'launches the js-version as examples/simple', (done) ->
      runBugger [ 'examples/simple' ], checkHelloWorld('js', done)
