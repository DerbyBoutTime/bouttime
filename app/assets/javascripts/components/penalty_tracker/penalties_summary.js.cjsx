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

  findPenalty: (skaterState, penaltyNumber) ->
    matches = (penalty for penalty in skaterState.penaltyStates when penalty.sort is penaltyNumber)
    matches[0]
  render: () ->
    containerClass = cx
      'penalties-summary': true
      'hidden': @props.hidden
    <div className={containerClass} >
      {@props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <div key={skaterIndex} className='row gutters-xs top-buffer'>
          <div className='col-xs-3 col-sm-3'>
            <button className='bt-btn btn-boxed' onClick={@props.selectionHandler.bind(null, skaterIndex)}>
              <strong>{skaterState.skater.number}</strong>
            </button>
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={1}
              penaltyState={@findPenalty(skaterState, 1)}
              teamStyle={@props.teamStyle}/>
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={2}
              penaltyState={@findPenalty(skaterState, 2)}
              teamStyle={@props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={3}
              penaltyState={@findPenalty(skaterState, 3)}
              teamStyle={@props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={4}
              penaltyState={@findPenalty(skaterState, 4)}
              teamStyle={@props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={5}
              penaltyState={@findPenalty(skaterState, 5)}
              teamStyle={@props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={6}
              penaltyState={@findPenalty(skaterState, 6)}
              teamStyle={@props.teamStyle} />
          </div>
          <div className='col-xs-3 col-sm-3'>
            <PenaltyIndicator
              penaltyNumber={7}
              penaltyState={@findPenalty(skaterState, 7)}
              teamStyle={@props.teamStyle}
              leftEarly={true} />
          </div>
        </div>
      , this}
    </div>