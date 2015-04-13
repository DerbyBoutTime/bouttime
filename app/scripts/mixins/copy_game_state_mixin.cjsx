module.exports =
  getInitialState: () ->
    gameState: @props.gameState
  componentWillReceiveProps: (nextProps) ->
    @setState(gameState: nextProps.gameState)
