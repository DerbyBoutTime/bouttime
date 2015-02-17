exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    teamState: React.PropTypes.object.isRequired

  getInitialState: () ->
    selectedSkaterIndex = null

  selectSkater: (skaterIndex) ->
    this.setState(selectedSkaterIndex: skaterIndex)

  render: () ->
    <div className="team-penalties">
      {this.props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <div key={skaterIndex} className='row gutters-xs'>
          <div className='col-xs-3 col-sm-3'>
            <button className='btn btn-block' onClick={this.selectSkater.bind(this, skaterIndex)}>
              <strong>{skaterState.skater.number}</strong>
            </button>
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator penaltyNumber={1} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator penaltyNumber={2} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator penaltyNumber={3} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator penaltyNumber={4} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator penaltyNumber={5} />
          </div>
          <div className='col-xs-1 col-sm-1'>
            <PenaltyIndicator penaltyNumber={6} />
          </div>
          <div className='col-xs-3 col-sm-3'>
            <PenaltyIndicator penaltyNumber={7} />
          </div>
        </div>
      , this}
      <SkaterPenalties
    </div>