assert = require 'assert'
helpers = require '../generators/template_helpers'

describe 'template helpers', ->
  describe '::user', ->
    it 'creates as much of a username + email string as possible with info provided', ->

      message = 'formats the name + email combo'
      user =
        name: 'Fuddyduddy'
        email: 'fd@example.com'
      assert.equal "#{user.name} <#{user.email}>", helpers.user(user), message

      message = 'returns just the name if email is missing'
      user = name: 'Fuddyduddy'
      assert.equal user.name, helpers.user(user), message

      message = 'returns just the email if name is missing'
      user = email: 'fd@example.com'
      assert.equal user.email, helpers.user(user), message

      describe 'given a user with only an email', ->
        it 'returns the email', ->
      message = 'passes through strings'
      user = 'Fuddyduddy'
      assert.equal user, helpers.user(user), 'passes through strings'

      message = 'explodes on falsey values like null or undefined'
      assert.throws ->
        helpers.user null
      , message

