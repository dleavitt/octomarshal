class App.Views.User extends Backbone.View
  tagName: "li"
  template: HBS['app/templates/user']

  render: ->
    @$el.html @template @model.toJSON()
    return @