fs = require 'fs'
path = require 'path'
yeoman = require 'yeoman-generator'
handlebarsEngine = require './handlebars_engine'
{underscored} = require 'underscore.string'

contributor = (user) ->
  if user.name and user.email
  then "#{user.name} <#{user.email}>"
  else user.name or user.email

module.exports = class GoodeggsNpmGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    options.engine = handlebarsEngine
    yeoman.generators.Base.apply this, arguments
    @on 'end', ->
      @installDependencies
        skipInstall: options['skip-install']
        bower: false

    @sourceRoot path.join __dirname, '../templates'
    @pkg = require '../package.json'

  askFor: ->
    cb = @async()

    prompts = [{
      type: 'input'
      name: 'pkgname'
      message: 'Name your package'
      default: @appname
    }, {
      type: 'input'
      name: 'description'
      message: 'Describe your package'
      default: ''

    }]
    @prompt prompts, ({@pkgname, @description}) =>
      cb()

  gitUser: ->
    gitConfig = require 'git-config'
    done = @async()
    gitConfig (err, config) =>
      @user = config?.user
      done()

  contributors: ->
    @contributors = [@user]
      .filter(Boolean)
      .map(contributor)
      .filter(Boolean)

  project: ->
    @copy '../.editorconfig', '.editorconfig'
    @copy 'gitignore', '.gitignore'
    @copy 'travis.yml', '.travis.yml'
    @template '_package.json', 'package.json'
    @template '_README.md', 'README.md'
    @write "#{underscored @pkgname}.js", ''

  test: ->
    @copy '../test/mocha.opts', 'test/mocha.opts'
    @copy 'test.coffee', "test/#{underscored @pkgname}.test.coffee"

  maybeGit: ->
    return if fs.existsSync '.git'
    @template 'git/config', '.git/config'
