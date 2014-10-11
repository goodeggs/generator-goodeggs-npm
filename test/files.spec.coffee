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

    describe 'README.md', ->
      it 'includes badges', ->
        assert.fileContent 'README.md', /// travis-ci ///
        assert.fileContent 'README.md', /// badge.fury.io/js ///

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

