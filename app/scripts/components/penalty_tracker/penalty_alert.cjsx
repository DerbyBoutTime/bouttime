React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyAlert'
  propTypes:
    skater: React.PropTypes.object.isRequired
  expelled: () ->
    @props.skater.penalties.some (skaterPenalty) ->
      skaterPenalty.penalty.name is 'Gross Misconduct'
  fouledOut: () ->
    @props.skater.penalties.length >= 7
  leftEarly: () ->
    false
  render: () ->
    containerClass = cx
      'penalty-alert text-center text-uppercase bt-box': true
      'box-warning': @leftEarly()
      'box-danger': @fouledOut() or @expelled()
    displayContent = switch
      when @expelled() then 'Expelled'
      when @fouledOut() then 'Foul Out'
      when @leftEarly() then 'Left Early'
      else 'Alert'
    <div className={containerClass}>
      <strong>{displayContent}</strong>
    </div>