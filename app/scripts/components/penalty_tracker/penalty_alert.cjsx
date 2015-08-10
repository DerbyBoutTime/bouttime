React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyAlert'
  propTypes:
    skater: React.PropTypes.object.isRequired
  render: () ->
    containerClass = cx
      'penalty-alert text-center text-uppercase bt-box': true
      'box-warning': @props.skater.leftEarly()
      'box-danger': @props.skater.fouledOut() or @props.skater.expelled()
    displayContent = switch
      when @props.skater.expelled() then 'Expelled'
      when @props.skater.fouledOut() then 'Foul Out'
      when @props.skater.leftEarly() then 'Left Early'
      else 'Alert'
    <div className={containerClass}>
      <strong>{displayContent}</strong>
    </div>