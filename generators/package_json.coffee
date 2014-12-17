helpers = require './template_helpers'
merge = require 'deepmerge'
{underscored} = require 'underscore.string'

module.exports = (data, overrides={}) ->
  json = base.apply(data)
  if data.angular
    json = merge json, angular.apply(data)
  if data.private
    json = merge json, puhrivate.apply(data)
  if data.vanillajs
    json = merge json, js.apply(data)
  json = merge json, overrides
  JSON.stringify json, null, 2

# Attributes with value undefined are omitted from generated JSON

base = ->
  name: @pkgname
  version: "1.0.0"
  description: @description
  author: "Good Eggs <open-source@goodeggs.com>"
  contributors: @contributors and @contributors.map helpers.user
  license: @license
  keywords: @keywords?.length and @keywords or undefined
  main: 'lib/index.js'
  repository:
    type: "git"
    url: "git://github.com/goodeggs/#{@reposlug}.git"
  homepage: "https://github.com/goodeggs/#{@reposlug}"
  bugs: "https://github.com/goodeggs/#{@reposlug}/issues"
  dependencies: {}
  devDependencies:
    "coffee-script": ">=1.8.x"
    "mocha": "~1.x.x"
  scripts:
    compile: "coffee --bare --compile --output lib/ src/"
    prepublish: "npm run compile"
    pretest: "npm run compile"
    test: "mocha"

angular = ->
  devDependencies:
    "uglify-js": "^2.4.12"
    "browserify": "^3.32.0"
    "bower": "^1.3.1"
    "karma-sinon-chai": "^0.1.5"
    "karma-coffee-preprocessor": "^0.2.1"
    "karma-mocha": "^0.1.6"
    "karma-phantomjs-launcher": "^0.1.4"
    "karma": "^0.12.21"
    "mocha": undefined
  scripts:
    test: "karma start"
    prepublish: "bower -sj install"
    link: "browserify lib/index.js > {{ pkgname }}.js"
    minify: "uglifyjs {{ pkgname }}.js > {{ pkgname }}.min.js"
    build: "npm run compile && npm run link && npm run minify"

js = ->
  devDependencies:
    jshint: '*'
  scripts:
    test: "jshint lib/*.js && mocha"
    prepublish: undefined
    pretest: undefined
    compile: undefined

puhrivate = ->
  publishConfig:
    registry: "https://goodeggs.registry.nodejitsu.com/"
    'always-auth': true
