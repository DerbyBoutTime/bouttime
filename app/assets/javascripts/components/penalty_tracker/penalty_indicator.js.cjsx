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
    if this.props.penaltyState? and this.props.penaltyState.penalty? then this.props.penaltyState.penalty.code else this.displayNumber()
  displayNumber: () ->
    if this.props.leftEarly then 'Left Early' else this.props.penaltyNumber
  render: () ->
    <div className='penalty-indicator' style={this.props.teamStyle if this.props.penaltyState?}>
      {this.displayContent()}
    </div>