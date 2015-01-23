require './spec_helper'
{spawn} = require 'child_process'
split = require 'split'
assert = require 'assert'
logProcess = require 'process-logger'

describe 'generated scripts', ->
  npm = (cmd, options, done) ->
    if not done
      done = options; options = {}

    child = spawn 'npm', [cmd]
    logProcess child, prefix: '[generated]'
    child.on 'close', done
    child

  install = (done) ->
    @timeout 60000
    npm 'install', (code) ->
      assert.equal code, 0, 'should not error'
      done()

  # Asserts that `npm test` fails with the expected message AssertionError
  test = (done) ->
    loggedAssertionError = false
    npm 'test', (code) ->
      assert loggedAssertionError, 'should show the mocha test failure'
      done()
    .stderr.pipe(split()).on 'data', (data) ->
      if /AssertionError: expected true to equal false/.test data
        loggedAssertionError = true

  describe 'using coffeescript', ->
    before (done) ->
      @runGenerator {vanillajs: false}, done

    it 'npm installs', install
    it 'npm test fails with expected message', test

  describe 'using javascript', ->
    before (done) ->
      @runGenerator {vanillajs: true}, done

    it '`npm install`s', install
    it '`npm test` fails with expected message', test

