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

        @fetchUsers = @org.fetchUsers()
        @fetchRepos = @org.fetchRepos()

        _.bindAll(@)

        @fetchRepos.done @renderRepos
        @fetchUsers.done @renderUsers

  changeRepo: (orgName, repoName) ->
    @changeOrg(orgName)
    @fetchOrgs.done =>
      @fetchRepos.done =>
        @renderRepoDetail

  renderOrgs: ->
    view = new App.Views.OrgSelector collection: @orgs
    @$orgSelector.html(view.render().el)

  renderRepos: ->
    # TODO: deal with org possibly being changed
    @$reposContainer.html('')
    @repoViews = @org.repos.map (repo) => new App.Views.RepoListing(model: repo)
    @repoViews.forEach (view) => @$reposContainer.append(view.render().el)

  renderUsers: ->
    @$usersContainer.html('')
    @userViews = @org.users.map (user) => new App.Views.User(model: user)
    @userViews.forEach (view) => @$usersContainer.append(view.render().el)

  logout: (e) ->
    e.preventDefault()
    $.post "/logout", (res) -> window.location = res.location
