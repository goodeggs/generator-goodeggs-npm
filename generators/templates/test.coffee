{{~#unless angular~}}
expect = require('chai').expect

{{camelize pkgname}} = require '..'

{{/unless~}}

describe '{{pkgname}}', ->
  it 'works', ->
    expect(true).to.equal false
