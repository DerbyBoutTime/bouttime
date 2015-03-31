cx = React.addons.classSet
exports = exports ? this
exports.PenaltiesSummary = React.createClass
  displayName: 'PenaltiesSummary'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
    hidden: React.PropTypes.bool
  getDefaultProps: () ->
    selectionHandler: () ->
    hidden: false
  getLineup: () ->
    jam = @props.teamState.jamStates[@props.teamState.jamStates.length-1]
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
      {@props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <div key={skaterIndex} className='row gutters-xs top-buffer'>
          <div className='col-xs-2'>
            <button className='bt-btn btn-boxed' onClick={@props.selectionHandler.bind(null, skaterIndex)} style={if @inLineup(skaterState.skater) and not @isInjured(skaterState.skater) then @props.teamState.colorBarStyle}>
              <strong>{skaterState.skater.number}</strong>
            </button>
          </div>
          {[0...7].map (i) ->
            <div key={i} className='col-xs-1'>
              <PenaltyIndicator
                penaltyNumber={i+1}
                penaltyState={skaterState.penaltyStates[i]}
                teamStyle={@props.teamState.colorBarStyle}/>
            </div>
          , this}
          <div className='col-xs-3'>
            <PenaltyAlert skaterState={skaterState} />
          </div>
        </div>
      , this}
    </div>