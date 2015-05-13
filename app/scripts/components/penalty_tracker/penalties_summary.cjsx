React = require 'react/addons'
PenaltyIndicator = require './penalty_indicator.cjsx'
PenaltyAlert = require './penalty_alert.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PenaltiesSummary'
  propTypes:
    team: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
    hidden: React.PropTypes.bool
  getDefaultProps: () ->
    selectionHandler: () ->
    hidden: false
  getLineup: () ->
    jam = @props.team.jams[@props.team.jams.length-1]
    positions = [jam.pivot, jam.blocker1, jam.blocker2, jam.blocker3, jam.jammer]
    positions.filter (position) ->
      position?
  inLineup: (skater) ->
    skater.number in @getLineup().map (s) -> s.number
  isInjured: (skater) ->
    false
  render: () ->
    containerClass = cx
      'penalties-summary': true
      'hidden': @props.hidden
    <div className={containerClass} >
      {@props.team.skaters.map (skater, skaterIndex) ->
        <div key={skaterIndex} className='row gutters-xs top-buffer'>
          <div className='col-xs-2'>
            <button className='bt-btn btn-boxed' onClick={@props.selectionHandler.bind(null, skater.id)} style={if @inLineup(skater) and not @isInjured(skater) then @props.team.colorBarStyle}>
              <strong>{skater.number}</strong>
            </button>
          </div>
          {[0...7].map (i) ->
            <div key={i} className='col-xs-1'>
              <PenaltyIndicator
                penaltyNumber={i+1}
                skaterPenalty={skater.penalties[i]}
                teamStyle={@props.team.colorBarStyle}/>
            </div>
          , this}
          <div className='col-xs-3'>
            <PenaltyAlert skater={skater} />
          </div>
        </div>
      , this}
    </div>