cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'

  mixins: [GameStateMixin, CopyGameStateMixin]

  updatePenaltyStates: (teamType, skaterIndex, penaltyStates) ->
    skater = this.getSkaterState(teamType, skaterIndex)
    skater.penaltyStates = penaltyStates.map (penaltyState) -> $.extend(true, {}, penaltyState)
    this.setState(this.state)
    exports.dispatcher.trigger 'penalty_tracker.update_penalties', this.buildOptions(teamType: teamType, skaterIndex: skaterIndex)

  buildOptions: (opts= {} ) ->
    stdOpts =
      role: 'Penalty Tracker'
      timestamp: Date.now
      state: this.state.gameState
    $.extend(stdOpts, opts)

  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()

  render: () ->
    awayElement = <TeamPenalties teamState={this.state.gameState.awayAttributes} penalties={this.state.gameState.penalties} currentJamNumber={this.props.gameState.jamNumber} applyHandler={this.updatePenaltyStates.bind(this, 'away')}/>
    homeElement = <TeamPenalties teamState={this.state.gameState.homeAttributes} penalties={this.state.gameState.penalties} currentJamNumber={this.props.gameState.jamNumber} applyHandler={this.updatePenaltyStates.bind(this, 'home')}/>

    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
