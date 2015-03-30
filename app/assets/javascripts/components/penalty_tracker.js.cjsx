cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'
  mixins: [GameStateMixin, CopyGameStateMixin]
  updatePenaltyStates: (teamType, skaterIndex, penaltyStates) ->
    skater = @getSkaterState(teamType, skaterIndex)
    skater.penaltyStates = penaltyStates.map (penaltyState) -> $.extend(true, {}, penaltyState)
    @setState(@state)
    exports.dispatcher.trigger 'penalty_tracker.update_penalties', @buildOptions(teamType: teamType, skaterIndex: skaterIndex)
  buildOptions: (opts= {} ) ->
    stdOpts =
      role: 'Penalty Tracker'
      timestamp: Date.now
      state: @state.gameState
    $.extend(stdOpts, opts)
  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()
  render: () ->
    awayElement = <TeamPenalties teamState={@state.gameState.awayAttributes} penalties={@state.gameState.penalties} currentJamNumber={@props.gameState.jamNumber} applyHandler={@updatePenaltyStates.bind(this, 'away')}/>
    homeElement = <TeamPenalties teamState={@state.gameState.homeAttributes} penalties={@state.gameState.penalties} currentJamNumber={@props.gameState.jamNumber} applyHandler={@updatePenaltyStates.bind(this, 'home')}/>
    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={@state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={@state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
