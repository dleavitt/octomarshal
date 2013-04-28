class App.Router extends Backbone.Router
  routes:
    '': 'main'
    'orgs/:org': 'org'

  initialize: ->
    @main = new App.Views.Main

  org: (orgName) ->
    @main.fetchOrgs.done =>
      @main.changeOrg(orgName)
    # TODO: show spinner
