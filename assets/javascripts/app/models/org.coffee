class App.Models.Org extends Backbone.Model
  initialize: (options) ->
    @repos = new App.Collections.Repos(org: @)
    @users = new App.Collections.Users(org: @)
    # TODO: users