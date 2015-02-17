cx = React.addons.classSet
exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired

  getInitialState: () ->
    selectedSkaterIndex : null

  selectSkater: (skaterIndex) ->
      this.setState(selectedSkaterIndex: skaterIndex)

  applySkaterPenalties:(workingSkaterState) ->
    this.setState(selectedSkaterIndex: null)

  cancelSkaterPenalties: () ->
    this.setState(selectedSkaterIndex: null)

  selectedSkater: () ->
    this.props.teamState.skaterStates[this.state.selectedSkaterIndex || 0]

  render: () ->
    skaterListClass = cx
      'skater-list': true
      'hidden': this.state.selectedSkaterIndex?

    skaterPenaltiesClass = cx
      'skater-penalties-container': true
      'hidden': !this.state.selectedSkaterIndex?

    <div className="team-penalties">
      <div className={skaterListClass} >
        {this.props.teamState.skaterStates.map (skaterState, skaterIndex) ->
          <div key={skaterIndex} className='row gutters-xs'>
            <div className='col-xs-3 col-sm-3'>
              <button className='btn btn-block' onClick={this.selectSkater.bind(this, skaterIndex)}>
                <strong>{skaterState.skater.number}</strong>
              </button>
            </div>
            <div className='col-xs-1 col-sm-1'>
              <PenaltyIndicator penaltyNumber={1} penaltyState={skaterState.penaltyStates[0]} />
            </div>
            <div className='col-xs-1 col-sm-1'>
              <PenaltyIndicator penaltyNumber={2} penaltyState={skaterState.penaltyStates[1]} />
            </div>
            <div className='col-xs-1 col-sm-1'>
              <PenaltyIndicator penaltyNumber={3} penaltyState={skaterState.penaltyStates[2]} />
            </div>
            <div className='col-xs-1 col-sm-1'>
              <PenaltyIndicator penaltyNumber={4} penaltyState={skaterState.penaltyStates[3]} />
            </div>
            <div className='col-xs-1 col-sm-1'>
              <PenaltyIndicator penaltyNumber={5} penaltyState={skaterState.penaltyStates[4]} />
            </div>
            <div className='col-xs-1 col-sm-1'>
              <PenaltyIndicator penaltyNumber={6} penaltyState={skaterState.penaltyStates[5]} />
            </div>
            <div className='col-xs-3 col-sm-3'>
              <PenaltyIndicator penaltyNumber={7} penaltyState={skaterState.penaltyStates[6]} />
            </div>
          </div>
        , this}
      </div>
      <div className={skaterPenaltiesClass}>
        <SkaterPenalties skaterState={this.selectedSkater()}
          penalties={this.props.penalties}
          applyHandler={this.applySkaterPenalties}
          cancelHandler={this.cancelSkaterPenalties}/>
      </div>
    </div>