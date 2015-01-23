{{~#unless angular~}}
require 'mocha-sinon'
expect = require('chai').expect

{{camelize pkgname}} = require '..'

{{/unless~}}

describe '{{pkgname}}', ->
  it 'works', ->
    expect(true).to.equal false
