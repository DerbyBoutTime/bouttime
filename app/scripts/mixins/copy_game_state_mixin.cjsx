exports = exports ? this
exports.CopyGameStateMixin =
  getInitialState: () ->
    gameState: @props.gameState
  componentWillReceiveProps: (nextProps) ->
    @setState(gameState: nextProps.gameState)
