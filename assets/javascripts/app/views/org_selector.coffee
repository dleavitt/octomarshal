class App.Views.OrgSelector extends Backbone.View
  tagName: "select"
  template: HBS['app/templates/org_selector']

  events:
    'change': 'onChange'

  render: ->
    @$el.html @template orgs: @collection.toJSON()
    return @

  onChange: ->
    org = @$el.val()
    @goto("#{org}") if org isnt ""
