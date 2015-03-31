cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'
  mixins: [GameStateMixin, CopyGameStateMixin]
  componentWillMount: () ->
    @actions =
      setPenalty: (teamType, skaterIndex, penaltyIndex) ->
        skaterState = @getSkaterState(teamType, skaterIndex)
        penalty = @getPenalty(penaltyIndex)
        lastPenaltyState = skaterState.penaltyStates[-1..][0]
        sort = if lastPenaltyState? then lastPenaltyState.sort + 1 else 0
        skaterState.penaltyStates.push
          penalty: penalty
          jamNumber: @state.gameState.jamNumber
          sort: sort
        exports.dispatcher.trigger 'penalty_tracker.set_penalty', @buildOptions(teamType: teamType, skaterIndex: skaterIndex)
        @setState(@state)
      clearPenalty: (teamType, skaterIndex, penaltyStateIndex) ->
        skaterState = @getSkaterState(teamType, skaterIndex)
        removedPenalty = skaterState.penaltyStates.splice(penaltyStateIndex, 1)[0]
        exports.dispatcher.trigger 'penalty_tracker.clear_penalty', @buildOptions(teamType: teamType, skaterIndex: skaterIndex, removedPenalty: removedPenalty)
        @setState(@state)
      updatePenalty: (teamType, skaterIndex, penaltyStateIndex, opts={}) ->
        penaltyState = @getPenaltyState(teamType, skaterIndex, penaltyStateIndex)
        $.extend(penaltyState, opts)
        exports.dispatcher.trigger 'penalty_tracker.update_penalty', @buildOptions(teamType: teamType, skaterIndex: skaterIndex, penaltyStateIndex: penaltyStateIndex)
        @setState(@state)
  bindActions: (teamType) ->
    Object.keys(@actions).map((key) ->
      key: key
      value: @actions[key].bind(this, teamType)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  buildOptions: (opts= {} ) ->
    stdOpts =
      role: 'Penalty Tracker'
      timestamp: Date.now
      state: @state.gameState
    $.extend(stdOpts, opts)
  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()
  render: () ->
    awayElement = <TeamPenalties teamState={@state.gameState.awayAttributes} penalties={@state.gameState.penalties} actions={@bindActions('away') }/>
    homeElement = <TeamPenalties teamState={@state.gameState.homeAttributes} penalties={@state.gameState.penalties} actions={@bindActions('home') }/>
    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={@state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={@state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
