path = require 'path'
helpers = require('yeoman-generator').test
assert = require('yeoman-generator').assert

describe 'goodeggs-npm generator', ->
  pkgname = 'french-omelette'
  description = "Dish made from beaten eggs quickly cooked with butter or oil in a frying pan"

  before (done) ->
    helpers.testDirectory path.join(__dirname, '../temp'), (err) =>
      if err
        return done(err)

      @app = helpers.createGenerator('goodeggs-npm:app', ['../app/index.js'])
      @app.options['skip-install'] = true

      helpers.mockPrompt @app, {pkgname, description}
      @app.run {}, ->
        done()

  it 'creates expected files', (done) ->
    assert.file [
      '.editorconfig'
      '.gitignore'
      '.travis.yml'
      'test/mocha.opts'
    ]
    done()

  describe 'package.json', ->
    it 'includes package name and description', ->
      assert.fileContent 'package.json', /// "name":\s"#{pkgname}" ///
      assert.fileContent 'package.json', /// "description":\s"#{description}" ///

  describe 'README.md', ->
    it 'includes package name and description', ->
      assert.fileContent 'README.md', /// #{pkgname} ///
      assert.fileContent 'README.md', /// #{description} ///

    it 'includes badges', ->
      assert.fileContent 'README.md', /// travis-ci ///
      assert.fileContent 'README.md', /// badge.fury.io/js ///

  describe 'test', ->
    it 'fails', (done) ->
      Mocha = require 'mocha'
      mocha = new Mocha reporter: (runner) ->
        runner.on 'fail', (test, err) ->
          assert /busted/.test err
          done()
      mocha.addFile "../temp/test/french_omelette.test.coffee"
      mocha.run()



