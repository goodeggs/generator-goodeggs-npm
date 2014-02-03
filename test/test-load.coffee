assert = require 'assert'

describe 'goodeggs-npm generator', ->
  it 'can be imported without blowing up', ->
    goodeggsNpm = require '../'
    assert(goodeggsNpm?)
