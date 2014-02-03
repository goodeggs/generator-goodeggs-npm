path = require 'path'
yeoman = require 'yeoman-generator'

module.exports = class GoodeggsNpmGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    yeoman.generators.Base.apply this, arguments
    @on 'end', ->
      @installDependencies
        skipInstall: options['skip-install']
        bower: false

    @pkg = require './package.json'

  askFor: ->
    cb = @async()

    # have Yeoman greet the user.
    # console.log @yeoman
    prompts = [
      type: 'confirm'
      name: 'someOption'
      message: 'Would you like to enable this option? This is just a test'
      default: true
    ]
    @prompt prompts, (props) =>
      @someOption = props.someOption
      cb()

  project: ->
    @copy '../.editorconfig', '.editorconfig'
    @copy 'gitignore', '.gitignore'
    @copy 'travis.yml', '.travis.yml'
    @copy '_package.json', 'package.json'

  test: ->
    @copy '../test/mocha.opts', 'test/mocha.opts'
