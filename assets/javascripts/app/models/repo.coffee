class App.Models.Repo extends Backbone.Model
  # TODO: order by updated_at
  checkForTeam: (teams) ->
    @teams = teams
    @team = teams.findWhere(slug: @get('name'))
    @set 'team', @team.get('id') if @team

  createTeam: ->
    @team = new App.Models.Team(slug: @get('name'))
    @listenToOnce @team, "sync", @teamAdded
    @teams.create(@team, { wait: true })

  teamAdded: ->
    log 'teamAdded', @
    @set 'team', @team.get('id')