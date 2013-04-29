class App.Views.RepoListing extends Backbone.View
  tagName: "div"
  attributes: class: "row"
  template: HBS['app/templates/repo_listing']

  events:
    'click .team-edit':   'repoSelected'
    'click .team-create': 'createTeam'

  initialize: ->
    @listenTo @model, "change:team", @refresh

  render: ->
    @$el.html @template @model.toJSON()
    return @

  refresh: ->
    @render()
    @$el.replaceWith(@el)
    @delegateEvents()

  createTeam: (e) ->
    e.preventDefault()
    @model.createTeam()

  repoSelected: (e) ->
    e.preventDefault()

    org   = @model.collection.org.get("login")
    repo  = @model.get("name")

    @goto "#{org}/#{repo}"

