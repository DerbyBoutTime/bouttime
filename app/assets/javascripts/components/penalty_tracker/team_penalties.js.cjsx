exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  render: () ->
    <span>{this.props.teamState.name}</span>