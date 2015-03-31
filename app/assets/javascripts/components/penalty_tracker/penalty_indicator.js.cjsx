cx = React.addons.classSet
exports = exports ? this
exports.PenaltyIndicator = React.createClass
  displayName: 'PenaltyIndicator'
  propTypes:
    penaltyNumber: React.PropTypes.number.isRequired
    penaltyState: React.PropTypes.object
    teamStyle: React.PropTypes.object.isRequired
    leftEarly: React.PropTypes.bool
  getDefaultProps: () ->
    leftEarly: false
  displayContent: () ->
    if @props.penaltyState? and @props.penaltyState.penalty? then @props.penaltyState.penalty.code else @props.penaltyNumber
  render: () ->
    containerClass = cx
      'penalty-indicator': true
      'warning': @props.penaltyState? and @props.penaltyNumber is 6
      'expulsion': @props.penaltyState? and @props.penaltyNumber is 7

    <div className={containerClass} style={@props.teamStyle if @props.penaltyState? and @props.penaltyNumber < 6}>
      <strong>{@displayContent()}</strong>
    </div>