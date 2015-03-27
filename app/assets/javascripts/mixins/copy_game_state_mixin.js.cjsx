exports = exports ? this
exports.CopyGameStateMixin =
  getInitialState: () ->
    gameState: this.props.gameState
  componentWillReceiveProps: (nextProps) ->
    this.setState(gameState: nextProps.gameState)
