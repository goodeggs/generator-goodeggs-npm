path = require 'path'
helpers = require('yeoman-generator').test

describe 'goodeggs-npm generator', ->
  beforeEach (done) ->
    helpers.testDirectory path.join(__dirname, '../temp'), (err) =>
      if err
        return done(err)

      @app = helpers.createGenerator('goodeggs-npm', ['../'])
      done()

  it 'creates expected files', (done) ->
    expected = [
      # add files you expect to exist here.
      '.editorconfig'
      '.gitignore'
      '.travis.yml'
      'package.json'
      'test/mocha.opts'
    ]

    helpers.mockPrompt @app,
      'someOption': true

    @app.options['skip-install'] = true
    @app.run {}, ->
      helpers.assertFiles(expected)
      done()
