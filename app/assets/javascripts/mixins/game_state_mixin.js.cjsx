exports = exports ? this
exports.GameStateMixin =
  getTeamState: (teamType) ->
    switch teamType
      when 'away' then @state.gameState.awayAttributes
      when 'home' then @state.gameState.homeAttributes
  getJamState: (teamType, jamIndex) ->
    @getTeamState(teamType).jamStates[jamIndex]
  getPassState: (teamType, jamIndex, passIndex) ->
    @getJamState(teamType, jamIndex).passStates[passIndex]
  getSkaterState: (teamType, skaterIndex) ->
    @getTeamState(teamType).skaterStates[skaterIndex]