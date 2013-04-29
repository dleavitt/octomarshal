class App.Views.Main extends Backbone.View
  el: "body"

  events:
    'click .log-out': 'logout'

  initialize: ->
    @orgs = new App.Collections.Orgs

    @$orgSelector       = @$(".orgs-selector-container")
    @$reposContainer    = @$(".repo-list-container")
    @$usersContainer    = @$(".org-users-container")

    @listenTo @orgs, "reset", @renderOrgs

    @fetchOrgs = @orgs.fetch(reset: true)

  changeOrg: (orgName) ->
    # TODO: check if this org is already selected
    # TODO: view cleanup
    @fetchOrgs.done =>
      unless @org?.get('login') is orgName
        @org = @orgs.findWhere(login: orgName)

        @listenToOnce @org.repos, "reset", @renderRepos
        @listenToOnce @org.users, "reset", @renderUsers

        @fetchRepos = @org.repos.fetch(reset: true)
        # @fetchTeams = @org.teams.fetch(reset: true)
        @fetchUsers = @org.users.fetch(reset: true)

  changeRepo: (orgName, repoName) ->
    @changeOrg(orgName)
    @fetchOrgs.done =>
      @fetchRepos.done =>
        log repoName

  renderOrgs: ->
    view = new App.Views.OrgSelector collection: @orgs
    @$orgSelector.html(view.render().el)

  renderRepos: ->
    # TODO: deal with org possibly being changed
    @$reposContainer.html('')
    @org.repos.forEach (repo) =>
      view = new App.Views.RepoListing(model: repo)
      @$reposContainer.append(view.render().el)

  renderUsers: ->
    @$usersContainer.html('')
    @org.users.forEach (user) =>
      view = new App.Views.User(model: user)
      @$usersContainer.append(view.render().el)

  logout: (e) ->
    e.preventDefault()
    $.post "/logout", (res) -> window.location = res.location
