cx = React.addons.classSet
exports = exports ? this
exports.PenaltyAlert = React.createClass
  displayName: 'PenaltyAlert'
  propTypes:
    skaterState: React.PropTypes.object.isRequired
  expelled: () ->
    @props.skaterState.penaltyStates.some (penaltyState) ->
      penaltyState.penalty.name is 'Gross Misconduct'
  fouledOut: () ->
    @props.skaterState.penaltyStates.length >= 7
  leftEarly: () ->
    false
  render: () ->
    containerClass = cx
      'penalty-alert': true
      'warning': @leftEarly()
      'expulsion': @fouledOut() or @expelled()
    displayContent = switch
      when @expelled() then 'Expelled'
      when @fouledOut() then 'Foul Out'
      when @leftEarly() then 'Left Early'
      else 'Alert'
    <div className={containerClass}>
      <strong>{displayContent}</strong>
    </div>