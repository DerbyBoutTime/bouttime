GameState = require '../models/game_state.coffee'
module.exports =
  getInitialState: () ->
    @loadState()
  loadState: () ->
    gameState: GameState.find(@props.gameStateId)
  onChange: () ->
    @setState(@loadState())
