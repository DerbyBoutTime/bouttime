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
    if @props.penaltyState? then "Jam #{@props.penaltyState.jamNumber}" else "Jam"
  render: () ->
    <div className='penalty-control'>
      <div className='jam-number'>
        <strong>{@jamNumberDisplay()}</strong>
      </div>
      <button className='bt-btn btn-boxed penalty-indicator-wrapper' onClick={@props.clickHandler}>
        <PenaltyIndicator {...@props}/>
      </button>
    </div>