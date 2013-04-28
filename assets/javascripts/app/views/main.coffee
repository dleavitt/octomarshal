class App.Views.Main extends Backbone.View
  el: "body"

  events:
    'click .log-out': 'logout'

  initialize: ->
    @orgs = new App.Collections.Orgs

    @$orgSelector       = @$(".orgs-selector-container")
    @$reposContainer    = @$(".repo-list-container")
    @$membersContainer  = @$(".members-container")

    @listenTo @orgs, "reset", @renderOrgs

    @fetchOrgs = @orgs.fetch(reset: true)

  renderOrgs: ->
    view = new App.Views.OrgSelector collection: @orgs
    @$orgSelector.html(view.render().el)

  changeOrg: (orgName) ->
    # TODO: check if this org is already selected
    # TODO: view cleanup
    @org = @orgs.findWhere(login: orgName)
    @listenToOnce @org.repos, "reset", @renderRepos
    @org.repos.fetch(reset: true)

  renderRepos: ->
    # TODO: deal with org possibly being changed
    @$reposContainer.html('')
    @org.repos.forEach (repo) =>
      view = new App.Views.RepoListing(model: repo)
      # log view.render().el
      @$reposContainer.append(view.render().el)

  logout: (e) ->
    e.preventDefault()
    $.post "/logout", (res) -> window.location = res.location
