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

  it 'names the node package', ->
    assert.fileContent 'package.json', /// "name":\s"#{pkgname}" ///

  it 'scaffolds a README', ->
    assert.fileContent 'README.md', /// #{pkgname} ///
    assert.fileContent 'README.md', /// #{description} ///
