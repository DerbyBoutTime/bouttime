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
      'hidden': this.props.hidden
    <div className={containerClass} >
      {this.props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <div key={skaterIndex} className='row gutters-xs top-buffer'>
          <div className='col-xs-3 col-sm-3'>
            <button className='btn btn-block btn-boxed' onClick={this.props.selectionHandler.bind(null, skaterIndex)}>
              <strong>{skaterState.skater.number}</strong>
            </button>
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={1}
              penaltyState={this.findPenalty(skaterState, 1)}
              teamStyle={this.props.teamStyle}/>
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={2}
              penaltyState={this.findPenalty(skaterState, 2)}
              teamStyle={this.props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={3}
              penaltyState={this.findPenalty(skaterState, 3)}
              teamStyle={this.props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={4}
              penaltyState={this.findPenalty(skaterState, 4)}
              teamStyle={this.props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={5}
              penaltyState={this.findPenalty(skaterState, 5)}
              teamStyle={this.props.teamStyle} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator
              penaltyNumber={6}
              penaltyState={this.findPenalty(skaterState, 6)}
              teamStyle={this.props.teamStyle} />
          </div>
          <div className='col-xs-3 col-sm-3'>
            <PenaltyIndicator
              penaltyNumber={7}
              penaltyState={this.findPenalty(skaterState, 7)}
              teamStyle={this.props.teamStyle}
              leftEarly={true} />
          </div>
        </div>
      , this}
    </div>