cx = React.addons.classSet
exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    currentJamNumber: React.PropTypes.number.isRequired
    applyHandler: React.PropTypes.func.isRequired

  getInitialState: () ->
    selectedSkaterIndex : null

  selectSkater: (skaterIndex) ->
    this.refs.skaterPenalties.resetState()
    this.setState(selectedSkaterIndex: skaterIndex)

  applySkaterPenalties:(workingSkaterState) ->
    this.props.applyHandler(this.state.selectedSkaterIndex, workingSkaterState.penaltyStates)
    this.setState(selectedSkaterIndex: null)

  cancelSkaterPenalties: () ->
    this.setState(selectedSkaterIndex: null)

  selectedSkater: () ->
    this.props.teamState.skaterStates[this.state.selectedSkaterIndex]

  render: () ->
    <div className="team-penalties">
      <PenaltiesSummary
        {...this.props}
        teamStyle={this.props.teamState.colorBarStyle}
        selectionHandler={this.selectSkater}
        hidden={this.state.selectedSkaterIndex?}/>
      <SkaterPenalties
        ref='skaterPenalties'
        skaterState={this.selectedSkater()}
        penalties={this.props.penalties}
        currentJamNumber={this.props.currentJamNumber}
        applyHandler={this.applySkaterPenalties}
        cancelHandler={this.cancelSkaterPenalties}
        teamStyle={this.props.teamState.colorBarStyle}
        hidden={!this.state.selectedSkaterIndex?}/>
    </div>