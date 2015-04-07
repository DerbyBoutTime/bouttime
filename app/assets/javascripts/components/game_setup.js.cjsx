cx = React.addons.classSet
exports = exports ? this
exports.GameSetup = React.createClass
  displayName: 'GameSetup'
  mixins: [GameStateMixin, CopyGameStateMixin]
  componentWillMount: () ->
    @actions =
      updateGame: (gameState) =>
        @setState(gameState: $.extend(@state.gameState, gameState))
      updateTeam: (teamType, teamState) =>
        team = @getTeamState(teamType)
        team = $.extend(team, teamState)
        @setState(@state)
      addSkater: (teamType) =>
        team = @getTeamState(teamType)
        team.skaterStates.push
          skater:
            name: ''
            number: ''
        @setState(@state)
      removeSkater: (teamType, skaterIndex) =>
        team = @getTeamState(teamType)
        team.skaterState.splice(skaterIndex, 1)
        @setState(@state)
      updateSkater: (teamType, skaterIndex, skater) =>
        skaterState = @getSkaterState(teamType, skaterIndex)
        skaterState.skater = $.extend(skaterState.skater, skater)
        @setState(@state)
      createGame: () =>
        exports.dispatcher.trigger 'game_setup.create_game', @buildOptions()
  buildOptions: (opts= {} ) ->
    stdOpts =
      role: 'Penalty Tracker'
      timestamp: Date.now
      state: @state.gameState
    $.extend(stdOpts, opts)
  render: () ->
    <div className="game-setup">
      <GameForm gameState={@state.gameState} actions={@actions}/>
    </div>