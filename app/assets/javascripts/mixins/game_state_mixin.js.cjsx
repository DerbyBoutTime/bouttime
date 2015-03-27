exports = exports ? this
exports.GameStateMixin =
  getTeamState: (teamType) ->
    switch teamType
      when 'away' then this.state.gameState.awayAttributes
      when 'home' then this.state.gameState.homeAttributes
  getJamState: (teamType, jamIndex) ->
    this.getTeamState(teamType).jamStates[jamIndex]
  getPassState: (teamType, jamIndex, passIndex) ->
    this.getJamState(teamType, jamIndex).passStates[passIndex]
  getSkaterState: (teamType, skaterIndex) ->
    this.getTeamState(teamType).skaterStates[skaterIndex]