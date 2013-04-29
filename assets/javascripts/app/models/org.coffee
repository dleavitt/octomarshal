class App.Models.Org extends Backbone.Model
  initialize: (options) ->
    @repos = new App.Collections.Repos(org: @)
    @teams = new App.Collections.Teams(org: @)
    @users = new App.Collections.Users(org: @)
    # TODO: users

  fetchUsers: -> @users.fetch(reset: true)

  fetchRepos: ->
    deferreds = (col.fetch(reset: true) for col in [@repos, @teams])
    # TODO: very inefficient
    $.when(deferreds...).done => @repos.map (repo) => repo.checkForTeam(@teams)

