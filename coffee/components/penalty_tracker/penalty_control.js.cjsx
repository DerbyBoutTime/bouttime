cx = React.addons.classSet
exports = exports ? this
exports.PenaltyControl = React.createClass
  displayName: 'PenaltyControl'
  propTypes:
    penaltyNumber: React.PropTypes.number
    penaltyState: React.PropTypes.object
    teamStyle: React.PropTypes.object.isRequired
    target: React.PropTypes.string.isRequired
  jamNumberDisplay: () ->
    if @props.penaltyState? then "Jam #{@props.penaltyState.jamNumber}" else "Jam"
  render: () ->
    <div className='penalty-control'>
      <div className='jam-number'>
        <strong>{@jamNumberDisplay()}</strong>
      </div>
      <button className='bt-btn btn-boxed penalty-indicator-wrapper'
        data-toggle="collapse"
        data-target={"##{@props.target}"}
        aria-expanded="false"
        aria-controls={@props.target}>
        <PenaltyIndicator {...@props}/>
      </button>
    </div>