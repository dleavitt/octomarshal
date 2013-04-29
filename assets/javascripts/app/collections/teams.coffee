class App.Collections.Teams extends Backbone.Collection
  model: App.Models.Team
  url: -> "/api/orgs/#{@org.get('login')}/teams"

  initialize: (options) ->
    {@org} = options