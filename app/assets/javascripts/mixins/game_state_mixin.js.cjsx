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
  getPenaltyState: (teamType, skaterIndex, penaltyStateIndex) ->
    @getSkaterState(teamType, skaterIndex).penaltyStates[penaltyStateIndex]
  getPenalty: (penaltyIndex) ->
    @state.gameState.penalties[penaltyIndex]
  getPenaltyBoxState: (teamType, boxIndex) ->
    @getTeamState(teamType).penaltyBoxStates[boxIndex]
