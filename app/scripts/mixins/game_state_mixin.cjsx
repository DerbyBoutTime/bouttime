module.exports =
  getTeam: (teamType) ->
    switch teamType
      when 'away' then @state.gameState.away
      when 'home' then @state.gameState.home
  getJam: (teamType, jamIndex) ->
    @getTeam(teamType).getJams()[jamIndex]
  getPass: (teamType, jamIndex, passIndex) ->
    @getJam(teamType, jamIndex).passes[passIndex]
  getSkater: (teamType, skaterIndex) ->
    @getTeam(teamType).skaters[skaterIndex]
  getSkaterPenalty: (teamType, skaterIndex, skaterPenaltyIndex) ->
    @getSkater(teamType, skaterIndex).penalties[skaterPenaltyIndex]
  getPenalty: (penaltyIndex) ->
    @state.gameState.penalties[penaltyIndex]
  getPenaltyBoxState: (teamType, boxIndex) ->
    @getTeam(teamType).penaltyBoxStates[boxIndex]
