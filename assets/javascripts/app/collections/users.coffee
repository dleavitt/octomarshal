class App.Collections.Users extends Backbone.Collection
  model: App.Models.User
  url: ->
    base = "/api/orgs/#{@org.get('login')}"
    if @repo
      "#{base}/repos/#{@repo.get('name')}/users"
    else
      "#{base}/users"

  initialize: (options) ->
    {@org, @repo} = options