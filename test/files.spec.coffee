require './spec_helper'
path = require 'path'
helpers = require('yeoman-generator').test
assert = require('yeoman-generator').assert

describe 'goodeggs-npm generated files', ->

  describe 'with default prompt values', ->
    before (done) ->
      @runGenerator {}, done

    it 'creates expected files', (done) ->
      assert.file [
        '.editorconfig'
        '.gitignore'
        '.travis.yml'
        'test/mocha.opts'
      ]
      done()

    describe 'package.json', ->
      it 'includes package name matching parent directory', ->
        assert.fileContent 'package.json', /// "name":\s"#{@reposlug}" ///

      it 'adds contributors', ->
        assert.fileContent 'package.json', /"contributors":/

  describe 'when user supplies a package name and description', ->
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

  describe 'private package', ->
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

    describe 'README.md', ->
      it 'includes private badges', ->
        assert.noFileContent 'README.md', /// badge.*npmjs\.org ///
        assert.fileContent 'README.md', /// magnum\.travis-ci\.com.*\.png ///

  describe 'open source package', ->
    before (done) ->
      @runGenerator {private: false}, done

    it 'includes code of conduct', ->
      assert.file 'CODE_OF_CONDUCT.md'

    it 'has a license file', ->
      assert.file 'LICENSE.md'

    describe 'package.json', ->
      it 'omits publishConfig', ->
        assert.noFileContent 'package.json', /"publishConfig":/

    describe 'README.md', ->
      it 'includes public badges', ->
        assert.fileContent 'README.md', /// badge.*npmjs\.org ///
        assert.fileContent 'README.md', /// travis-ci\.org.*\.png ///

      it 'leaves no empty lines in between the badegs so they flow nicely', ->
        assert.fileContent 'README.md', /NPM version.*\n.*Build Status/

