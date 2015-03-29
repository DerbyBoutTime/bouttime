cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'
  mixins: [GameStateMixin, CopyGameStateMixin]
  componentWillMount: () ->
    this.actions = 
      setPenalty: (teamType, skaterIndex, penaltyIndex) ->
        skaterState = this.getSkaterState(teamType, skaterIndex)
        penalty = this.getPenalty(penaltyIndex)
        skaterState.penaltyStates.push
          penalty: penalty
          jamNumber: this.state.gameState.jamNumber
        exports.dispatcher.trigger 'penalty_tracker.set_penalty', this.buildOptions(teamType: teamType, skaterIndex: skaterIndex)
        this.setState(this.state)
      clearPenalty: (teamType, skaterIndex, penaltyStateIndex) ->
        skaterState = this.getSkaterState(teamType, skaterIndex)
        skaterState.penaltyState.splice(penaltyStateIndex, 1)
        exports.dispatcher.trigger 'penalty_tracker.clear_penalty', this.buildOptions(teamType: teamType, skaterIndex: skaterIndex)
        this.setState(this.state)
      updatePenalty: (teamType, skaterIndex, penaltyStateIndex, opts={}) ->
        penaltyState = this.getPenaltyState(teamType, skaterIndex, penaltyStateIndex)
        $.extend(penaltyState, opts)
        exports.dispatcher.trigger 'penalty_tracker.update_penalty', this.buildOptions(teamType: teamType, skaterIndex: skaterIndex)
        this.setState(this.state)
  bindActions: (teamType) ->
    Object.keys(this.actions).map((key) ->
      key: key
      value: this.actions[key].bind(this, teamType)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  buildOptions: (opts= {} ) ->
    stdOpts =
      role: 'Penalty Tracker'
      timestamp: Date.now
      state: this.state.gameState
    $.extend(stdOpts, opts)
  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()
  render: () ->
    awayElement = <TeamPenalties teamState={this.state.gameState.awayAttributes} penalties={this.state.gameState.penalties} actions={this.bindActions('away')}/>
    homeElement = <TeamPenalties teamState={this.state.gameState.homeAttributes} penalties={this.state.gameState.penalties} actions={this.bindActions('home')}/>
    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
