React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyIndicator'
  propTypes:
    penaltyNumber: React.PropTypes.number.isRequired
    skaterPenalty: React.PropTypes.object
    teamStyle: React.PropTypes.object.isRequired
    leftEarly: React.PropTypes.bool
  getDefaultProps: () ->
    leftEarly: false
  displayContent: () ->
    if @props.skaterPenalty? and @props.skaterPenalty.penalty? then @props.skaterPenalty.penalty.code else @props.penaltyNumber
  render: () ->
    containerClass = cx
      'penalty-indicator': true
      'warning': @props.skaterPenalty? and @props.penaltyNumber is 6
      'expulsion': @props.skaterPenalty? and @props.penaltyNumber is 7

    <div className={containerClass} style={@props.teamStyle if @props.skaterPenalty? and @props.penaltyNumber < 6}>
      <strong>{@displayContent()}</strong>
    </div>