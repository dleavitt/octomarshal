class App.Views.RepoListing extends Backbone.View
  tagName: "div"
  attributes: class: "row"
  template: HBS['app/templates/repo_listing']

  events:
    'click .repo-name': 'repoSelected'

  render: ->
    @$el.html @template @model.toJSON()
    return @

  repoSelected: (e) ->
    e.preventDefault()

    org   = @model.collection.org.get("login")
    repo  = @model.get("name")

    @goto "#{org}/#{repo}"

