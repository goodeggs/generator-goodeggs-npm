require './spec_helper'
path = require 'path'
helpers = require('yeoman-generator').test
assert = require('yeoman-generator').assert

describe 'goodeggs-npm generated files', ->

  describe 'default prompt values', ->
    before (done) ->
      @runGenerator {}, done

    it 'creates expected files', (done) ->
      assert.file [
        '.editorconfig'
        '.gitignore'
        '.npmignore'
        '.travis.yml'
        'test/mocha.opts'
      ]
      done()

    describe 'package.json', ->
      it 'includes package name matching parent directory', ->
        assert.fileContent 'package.json', /// "name":\s"#{@reposlug}" ///

      it 'main links to the source file', ->
        assert.fileContent 'package.json', /// "main":\s"lib\/index.js" ///

      it 'adds contributors', ->
        assert.fileContent 'package.json', /"contributors":/

  describe 'custom package name and description', ->
    pkgtitle = 'French Omelette'
    description = "Dish made from beaten eggs quickly cooked with butter or oil in a frying pan"

    before (done) ->
      @runGenerator {pkgtitle, description}, done

    describe 'package.json', ->
      it 'includes supplied package name and description', ->
        assert.fileContent 'package.json', /// "name":\s"french-omelette" ///
        assert.fileContent 'package.json', /// "description":\s"#{description}" ///

      it 'does not use parent directory name', ->
        assert.noFileContent 'package.json', /// "name":\s"#{@reposlug}" ///

    describe 'README.md', ->
      it 'includes package name and description', ->
        assert.fileContent 'README.md', /// #{pkgtitle} ///
        assert.fileContent 'README.md', /// #{description} ///

  describe 'proprietary', ->
    before (done) ->
      @runGenerator {private: true}, done

    it 'excludes code of conduct', ->
      assert.noFile 'CODE_OF_CONDUCT.md'

    it 'has no license file', ->
      assert.noFile 'LICENSE.md'

    describe 'package.json', ->
      it 'flags the package as private', ->
        assert.fileContent 'package.json', /// "license":\s"Private" ///

      it 'restricts publishing to our private registry', ->
        assert.fileContent 'package.json', /"publishConfig":/
        assert.fileContent 'package.json', /https:\/\/goodeggs\.registry/

      it 'open-source is not the author', ->
        assert.fileContent 'package.json', /"author":/
        assert.noFileContent 'package.json', /"author":.*open-source@goodeggs\.com/

    describe 'README.md', ->
      it 'includes private badges', ->
        assert.noFileContent 'README.md', /// shields\.io\/npm ///
        assert.fileContent 'README.md', /// magnum\.travis-ci\.com.*\.png ///

      it 'includes no license badge', ->
        assert.noFileContent 'README.md', /License/

      it 'includes no mention of the code of conduct', ->
        assert.noFileContent 'README.md', /Code of Conduct/

      it 'provides a coffeescript usage example', ->
        assert.fileContent 'README.md', /require 'node-french-omelette'/

  describe 'open source', ->
    keywords = ['sesquipedalian', 'prolix']
    before (done) ->
      @runGenerator {private: false, keywords}, done

    it 'includes code of conduct', ->
      assert.file 'CODE_OF_CONDUCT.md'

    it 'has a license file', ->
      assert.file 'LICENSE.md'

    describe 'package.json', ->
      it 'omits publishConfig', ->
        assert.noFileContent 'package.json', /"publishConfig":/

      it 'includes keywords', ->
        assert.fileContent 'package.json', /"keywords": \[/
        for keyword in keywords
          assert.fileContent 'package.json', /// "#{keyword} ///

      it 'open-source is the author', ->
        assert.fileContent 'package.json', /"author":.*open-source@goodeggs\.com/

    describe 'README.md', ->
      it 'includes public badges', ->
        assert.fileContent 'README.md', /// shields\.io\/npm ///
        assert.fileContent 'README.md', /// shields\.io\/travis ///

      it 'leaves no empty lines in between the badegs so they flow nicely', ->
        assert.fileContent 'README.md', /NPM version.*\n.*Build Status/

      it 'includes a license badge with a link to the license file', ->
        assert.fileContent 'README.md', ///http://img.shields.io/badge/license-///
        assert.fileContent 'README.md', ////blob/master/LICENSE.md///

      it 'mentions the code of conduct', ->
        assert.fileContent 'README.md', /Code of Conduct/

      it 'provides a javascript usage example', ->
        assert.fileContent 'README.md', ///require\('node-french-omelette'\);///

  describe 'coffeescript', ->
    before (done) ->
      @runGenerator {vanillajs: false}, done

    it 'creates a file for the module in the src directory', ->
      assert.file 'src/index.coffee'

    it 'ignores lib folder', ->
      assert.fileContent '.gitignore', ///lib\////

  describe 'vanillajs', ->
    before (done) ->
      @runGenerator {vanillajs: true}, done

    it 'creates a file for the module in the lib directory', ->
      assert.file 'lib/index.js'

    it 'does not ignore lib folder', ->
      assert.noFileContent '.gitignore', ///lib\////

    describe 'package.json', ->
      it 'depends on jshint at development time', ->
        assert.fileContent 'package.json', /// "jshint": ///

      it 'runs jshint with tests', ->
        assert.fileContent 'package.json', /// "test":.*jshint ///
