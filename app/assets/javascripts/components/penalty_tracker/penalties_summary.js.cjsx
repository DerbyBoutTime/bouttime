cx = React.addons.classSet
exports = exports ? this
exports.PenaltiesSummary = React.createClass
  displayName: 'PenaltiesSummary'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    teamStyle: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
    hidden: React.PropTypes.bool

  render: () ->
    containerClass = cx
      'penalties-summary': true
      'hidden': @props.hidden
    <div className={containerClass} >
      {@props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <div key={skaterIndex} className='row gutters-xs top-buffer'>
          <div className='col-xs-2'>
            <button className='bt-btn btn-boxed' onClick={@props.selectionHandler.bind(null, skaterIndex)}>
              <strong>{skaterState.skater.number}</strong>
            </button>
          </div>
          {[0...7].map (i) ->
            <div key={i} className='col-xs-1'>
              <PenaltyIndicator
                penaltyNumber={i+1}
                penaltyState={skaterState.penaltyStates[i]}
                teamStyle={@props.teamStyle}/>
            </div>
          , this}
          <div className='col-xs-3'>
            <PenaltyAlert skaterState={skaterState} />
          </div>
        </div>
      , this}
    </div>