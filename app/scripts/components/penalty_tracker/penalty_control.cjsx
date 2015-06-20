React = require 'react/addons'
PenaltyIndicator = require './penalty_indicator.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltyControl'
  propTypes:
    penaltyNumber: React.PropTypes.number
    skaterPenalty: React.PropTypes.object
    teamStyle: React.PropTypes.object.isRequired
    target: React.PropTypes.string.isRequired
  jamNumberDisplay: () ->
    if @props.skaterPenalty? then "Jam #{@props.skaterPenalty.jamNumber}" else "Jam"
  render: () ->
    <div className='penalty-control'>
      <div className='jam-number'>
        <strong>{@jamNumberDisplay()}</strong>
      </div>
      <button className='penalty-control-button'
        data-toggle="collapse"
        data-target={"##{@props.target}"}
        aria-expanded="false"
        aria-controls={@props.target}>
        <PenaltyIndicator {...@props}/>
      </button>
    </div>