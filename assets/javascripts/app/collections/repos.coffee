class App.Collections.Repos extends Backbone.Collection
  model: App.Models.Repo
  url: -> "/api/orgs/#{@org.get('login')}/repos"

  initialize: (options) ->
    {@org} = options
