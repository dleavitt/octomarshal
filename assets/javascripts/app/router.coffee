class App.Router extends Backbone.Router
  routes:
    '':            'main'
    ':org':        'org'
    ':org/:repo':  'repo'

  initialize: ->
    @main = new App.Views.Main

  org: (orgName) -> @main.changeOrg(orgName)
  repo: (orgName, repoName) -> @main.changeRepo(orgName, repoName)