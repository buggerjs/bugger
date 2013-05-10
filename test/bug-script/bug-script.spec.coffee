
expect = require 'expect.js'

_bugScript = require '../../lib/bug-script'

describe 'forked', ->
  describe 'script', ->
    forked = null

    forkScript = (moduleName, childArgs..., cb) ->
      # if arguments.length == 2
      #   cb = childArgs
      #   childArgs = []

      _bugScript moduleName, childArgs..., (err, _forked) ->
        throw err if err?
        forked = _forked
        cb()

    beforeEach ->
      if forked?
        throw new Error('Leaked process: ' + forked.pid)

    afterEach (done) ->
      if forked? && forked.exitCode == null
        forked.on 'exit', -> done()
        forked.kill('SIGKILL')
        forked = null
      else
        forked = null
        done()

    it 'returns a process', (done) ->
      forkScript 'examples/simple.js', ->
        expect(forked.pid).to.be.a 'number'
        expect(forked.kill).to.be.a 'function'
        done()

    it 'opens an IPC channel', (done) ->
      forkScript 'examples/simple.js', ->
        expect(forked.send).to.be.a 'function'
        done()

    it 'returns a debug port for the process', (done) ->
      forkScript 'examples/simple.js', ->
        expect(parseInt forked.debugPort).to.be.a 'number'
        expect(parseInt forked.debugPort).to.be.greaterThan 1000
        done()

    ['js', 'coffee'].forEach (extension) ->
      it "exposes output of #{extension}-scripts to the parent process", (done) ->
        data = {}

        forkScript "examples/simple.#{extension}", ->
          forked.on 'debugConnection', ->
            calledOnce = false
            checkOutput = ->
              return if calledOnce
              calledOnce = true
              testAnyhowTimeout = null
              expect(data.stderr).to.be "Log to stderr\n"
              expect(data.stdout).to.be "Log to stdout\n"
              done()

            setTimeout checkOutput, 1000

            ['stdout', 'stderr'].forEach (streamName) ->
              data[streamName] = ''
              forked[streamName].on 'data', (chunk) ->
                data[streamName] += chunk.toString()
                if data.stderr is "Log to stderr\n" and data.stdout is "Log to stdout\n"
                  checkOutput()
