fs = require 'fs'
path = require 'path'
yeoman = require 'yeoman-generator'
handlebarsEngine = require 'yeoman-handlebars-engine'
{underscored, dasherize} = require 'underscore.string'
childProcess = require 'child_process'

contributor = (user) ->
  if user.name and user.email
  then "#{user.name} <#{user.email}>"
  else user.name or user.email

bundleExec = (args..., done) ->
  args.unshift 'exec'
  env = Object.create process.env
  env.BUNDLE_GEMFILE = path.join __dirname, '../Gemfile'
  child = childProcess.spawn 'bundle', args,
    stdio: 'inherit'
    env: env
  child.on 'close', done

hub = (args...) -> bundleExec 'hub', args...

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

    @reposlug = path.basename process.cwd()

  askFor: ->
    cb = @async()

    prompts = [{
      type: 'input'
      name: 'pkgname'
      message: 'Name your NPM package'
      default: @reposlug
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

  git: ->
    done = @async()
    hub 'init', done
