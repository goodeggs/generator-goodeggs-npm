fs = require 'fs'
path = require 'path'
yeoman = require 'yeoman-generator'
handlebarsEngine = require 'yeoman-handlebars-engine'
childProcess = require 'child_process'

contributor = (user) ->
  if user.name and user.email
  then "#{user.name} <#{user.email}>"
  else user.name or user.email

git = (args..., done) ->
  env = Object.create process.env
  child = childProcess.spawn 'git', args,
    stdio: 'inherit'
    env: env
  child.on 'close', done

module.exports = class GoodeggsNpmGenerator extends yeoman.generators.Base
  constructor: (args, options, config) ->
    options.engine = handlebarsEngine
    yeoman.generators.Base.apply @, arguments
    @on 'end', ->
      @installDependencies
        skipInstall: options['skip-install']
        bower: false

    @sourceRoot path.join __dirname, '../templates'
    @pkg = require '../package.json'

    @reposlug = path.basename process.cwd()

  askFor: ->
    cb = @async()

    prompts = [
      {
        type: 'input'
        name: 'pkgtitle'
        message: 'Name your NPM package'
        default: @_.titleize @_.humanize @reposlug
      }
      {
        type: 'input'
        name: 'description'
        message: 'Describe your package'
        default: ''
      }
      {
        type: 'list'
        name: 'license'
        message: 'What license would you like to use?'
        choices: ['MIT', 'LGPL']
        default: 'MIT'
      }
    ]
    @prompt prompts, ({@pkgtitle, @description, @license}) =>
      @pkgname = @_.dasherize @pkgtitle.toLowerCase()
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
    @copy "LICENSE_#{@license}.md", 'LICENSE.md'
    @copy 'CODE_OF_CONDUCT.md', 'CODE_OF_CONDUCT.md'
    @template '_package.json', 'package.json'
    @template '_README.md', 'README.md'
    @write "#{underscored @pkgname}.js", ''

  test: ->
    @copy '../test/mocha.opts', 'test/mocha.opts'
    @copy 'test.coffee', "test/#{underscored @pkgname}.test.coffee"

  git: ->
    done = @async()
    git 'init', done
