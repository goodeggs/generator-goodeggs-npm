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
    @quiet = options.quiet
    yeoman.generators.Base.apply @, arguments
    @on 'end', ->
      @installDependencies
        skipInstall: options['skip-install']
        bower: false

    @sourceRoot path.join __dirname, '../templates'
    @pkg = require '../../package.json'

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
        name: 'private'
        message: 'Is this a private Good Eggs-only package or Open Source?'
        default: true
        choices: [
          {name: 'Private', value: true}
          {name: 'Open Source', value: false}
        ]
      }
      {
        type: 'list'
        name: 'license'
        message: 'What license would you like to use?'
        choices: ['MIT', 'LGPL']
        default: 'MIT'
        when: (answers) -> not answers.private
      }
      {
        type: 'input'
        name: 'keywords'
        message: 'Keywords?'
        default: ''
        when: (answers) -> not answers.private
        filter: (input) ->
          input.split(',')
          .map((term) -> term.trim())
          .filter(Boolean)
      }
      {
        type: 'list'
        name: 'framework'
        message: 'Is this a plugin for a framework?'
        choices: [
          {name: 'nope', value: 'none'}
          {name: 'AngularJS', value: 'angular'}
        ]
      }
    ]
    @prompt prompts, ({framework, @pkgtitle, @description, @private, @license, @keywords}) =>
      @pkgname = @_.dasherize @pkgtitle.toLowerCase()
      @angular = framework is 'angular'
      if @private
        @license = 'Private'
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
    @copy '../../.editorconfig', '.editorconfig'
    @copy 'gitignore', '.gitignore'
    @copy 'travis.yml', '.travis.yml'
    @copy "LICENSE_#{@license}.md", 'LICENSE.md' unless @private
    @copy 'CODE_OF_CONDUCT.md', 'CODE_OF_CONDUCT.md' unless @private
    @template '_bower.json', 'bower.json' if @angular
    @template '_README.md', 'README.md'

    @mkdir 'src'
    @copy '_index.coffee', 'src/index.coffee'

    @mkdir 'lib'
    @write "lib/index.js", '// source code goes here\n'

  packageJson: ->
    packageJson = require '../package_json'
    @write 'package.json', packageJson(@)

  test: ->
    @copy '../../test/mocha.opts', 'test/mocha.opts' unless @angular
    @template '_karma.conf.js', 'karma.conf.js' if @angular
    @copy 'test.coffee', "test/#{@_.underscored @pkgname}.test.coffee"

  git: ->
    done = @async()
    git 'init', done

  hatch: ->
    return if @quiet
    hatch = require 'chicken-hatchling'
    hatch 1200, @async()
