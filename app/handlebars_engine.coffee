Handlebars = require 'handlebars'
_ = require 'underscore.string'

# TODO: PR into yeoman/generator https://github.com/yeoman/generator/blob/eef64d4948dfc3989bff5100eea5b727fda8764d/lib/util/engines.js#L6
#       Or extract into its own module

module.exports = engine = (source, data) ->
  Handlebars.compile(source)(data)

engine.detect = (body) ->
  body.indexOf('{{') > -1

for helper in [
  'camelize'
  'dasherize'
  'underscored'
]
  Handlebars.registerHelper helper, _[helper]
