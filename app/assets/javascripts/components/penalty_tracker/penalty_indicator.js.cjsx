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
    if @props.penaltyState? and @props.penaltyState.penalty? then @props.penaltyState.penalty.code else @displayNumber()
  displayNumber: () ->
    if @props.leftEarly then 'Left Early' else @props.penaltyNumber
  render: () ->
    <div className='penalty-indicator' style={@props.teamStyle if @props.penaltyState?}>
      {@displayContent()}
    </div>