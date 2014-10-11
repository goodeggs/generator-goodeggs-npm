module.exports =
  user: (user) ->
    switch
      when not user
        throw new Error 'who you tryin to format?!'
      when user.name and user.email
        "#{user.name} <#{user.email}>"
      when user.name or user.email
        user.name or user.email
      else
        user

  register: ->
    Handlebars = require 'handlebars'
    for helper in ['user']
      Handlebars.registerHelper(helper, @[helper]);
