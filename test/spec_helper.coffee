path = require 'path'
helpers = require('yeoman-generator').test

before ->
  @reposlug = 'node-french-omelette' # prefix with node to test module name different from repo name
  @runGenerator = (responses, done) ->
    helpers.testDirectory path.join(__dirname, 'generated', @reposlug), (err) =>
      if err
        return done(err)

      options =
        'skip-install': true
        'quiet': true
      @app = helpers.createGenerator('goodeggs-npm:app', ['../../../app/index.js'], [], options)

      helpers.mockPrompt @app, responses
      @app.run {pkgname: 'foo'}, ->
        done()
