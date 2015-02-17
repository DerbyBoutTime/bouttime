exports = exports ? this
exports.SkaterPenalties = React.createClass
  displayName: 'SkaterPenalties'
  propTypes:
    skaterState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    applyHandler: React.PropTypes.func
    cancelHandler: React.PropTypes.func

  getInitialState: () ->
    workingSkaterState: $.extend(true, this.props.skaterState)

  render: () ->
    <div className='skater-penalties'>
      <div className='row gutters-xs actions' >
        <div className='col-sm-6 col-xs-6'>
          <button className='btn btn-block' onClick={this.props.applyHandler.bind(null, this.state.workingSkaterState)} >
            <strong>Apply</strong>
          </button>
        </div>
        <div className='col-sm-6 col-xs-6'>
          <button className='btn btn-block' onClick={this.props.cancelHandler}>
            <strong>Cancel</strong>
          </button>
        </div>
      </div>
      <div className='row gutters-xs'>
        <div className='col-sm-2 col-xs-2'>
          <div className='btn btn-block'>
            <strong>{this.props.skaterState.skater.number}</strong>
          </div>
        </div>
      </div>
      <div className='row gutters-xs penalty-indicators'>
        <div className='col-xs-10 col-sm-10'>
          <div className='row gutters-xs'>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyIndicator penaltyNumber={1} penaltyState={this.props.skaterState.penaltyStates[0]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyIndicator penaltyNumber={2} penaltyState={this.props.skaterState.penaltyStates[1]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyIndicator penaltyNumber={3} penaltyState={this.props.skaterState.penaltyStates[2]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyIndicator penaltyNumber={4} penaltyState={this.props.skaterState.penaltyStates[3]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyIndicator penaltyNumber={5} penaltyState={this.props.skaterState.penaltyStates[4]} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyIndicator penaltyNumber={6} penaltyState={this.props.skaterState.penaltyStates[5]} />
            </div>
          </div>
        </div>
        <div className='col-xs-2 col-sm-2'>
          <PenaltyIndicator penaltyNumber={7} penaltyStates={this.props.skaterState.penaltyStates[6]} />
        </div>
      </div>
      <div className='row gutters-xs penalties-list'>
        {this.props.penalties.map (penalty, penaltyIndex) ->
          <div key={penaltyIndex} className='penalty'>
            <div className='col-xs-1 col-sm-1'>
              <div className='penalty-code'>
                <strong>{penalty.code}</strong>
              </div>
            </div>
            <div className='col-xs-5 col-sm-5'>
              <div className='penalty-name'>
                <strong>{penalty.name}</strong>
              </div>
            </div>
          </div>
        , this}
      </div>
    </div>