cx = React.addons.classSet
exports = exports ? this
exports.PenaltyControl = React.createClass
  render: () ->
  propTypes:
    penaltyNumber: React.PropTypes.number.isRequired
    penaltyState: React.PropTypes.object
    clickHandler: React.PropTypes.func
    teamStyle: React.PropTypes.object.isRequired
  jamNumberDisplay: () ->
    if this.props.penaltyState? then "Jam #{this.props.penaltyState.jamNumber}" else "Jam"
  render: () ->
    <div className='penalty-control'>
      <div className='jam-number'>
        <strong>{this.jamNumberDisplay()}</strong>
      </div>
      <button className='btn btn-block btn-boxed penalty-indicator-wrapper' onClick={this.props.clickHandler}>
        <PenaltyIndicator {...this.props}/>
      </button>
    </div>