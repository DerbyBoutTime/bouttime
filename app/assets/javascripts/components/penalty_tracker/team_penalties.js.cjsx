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
    <div className="team-penalties">
      <PenaltiesSummary
        {...this.props}
        selectionHandler={this.selectSkater}
        hidden={this.state.selectedSkaterIndex?}/>
      <SkaterPenalties
        skaterState={this.selectedSkater()}
        penalties={this.props.penalties}
        applyHandler={this.applySkaterPenalties}
        cancelHandler={this.cancelSkaterPenalties}
        teamStyle={this.props.teamState.colorBarStyle}
        hidden={!this.state.selectedSkaterIndex?}/>
    </div>