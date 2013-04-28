#= require jquery
#= require underscore
#= require backbone
#= require handlebars.runtime
#= require_self
#= require_tree ./app/templates
#= require_tree ./app/views
#= require_tree ./app/models
#= require_tree ./app/collections
#= require ./app/router

window.log = -> @console?.log?(arguments...)

$.ajaxSetup beforeSend: (xhr) ->
  token = $('meta[name="_csrf"]').attr("content")
  xhr.setRequestHeader "X_CSRF_TOKEN", token


window.App =
  Models: {}
  Collections: {}
  Views: {}
  initialize: ->
    router = @router = new App.Router
    Backbone.View.prototype.goto = (uri) -> router.navigate(uri, true)
    Backbone.history.start()

$ -> App.initialize()