{{~#unless angular}}
{{camelize pkgname}} = require '..'

{{/unless~}}

describe '{{pkgname}}', ->
  it 'works', ->
    throw new Error 'busted'
