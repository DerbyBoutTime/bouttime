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
  getPenaltyBoxState: (teamType, jamIndex, position) ->
    jam = @getJamState(teamType, jamIndex)
    switch position
      when 'jammer' then jam.jammerBoxState
      when 'blocker1' then jam.blocker1BoxState
      when 'blocker2' then jam.blocker2BoxState
