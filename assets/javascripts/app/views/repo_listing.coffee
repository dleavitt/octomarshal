class App.Views.RepoListing extends Backbone.View
  tagName: "div"
  attributes: class: "row"
  template: HBS['app/templates/repo_listing']

  render: ->
    @$el.html @template @model.toJSON()
    return @