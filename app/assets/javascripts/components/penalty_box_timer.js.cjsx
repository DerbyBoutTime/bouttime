cx = React.addons.classSet
exports = exports ? this
exports.PenaltyBoxTimer = React.createClass
  displayName: 'PenaltyBoxTimer'
  mixins: [GameStateMixin, CopyGameStateMixin]
  componentWillMount: () ->
    @actions =
      toggleLeftEarly: (teamType, jamIndex, position) ->
        box = @getPenaltyBoxState(teamType, jamIndex, position)
        box.leftEarly = !box.leftEarly
        box.served = false
        @setState(@state)
      toggleServed: (teamType, jamIndex, position) ->
        box = @getPenaltyBoxState(teamType, jamIndex, position)
        box.served = !box.served
        box.leftEarly = false
        @setState(@state)
      setSelectorContext: (teamType, jamIndex, selectHandler) ->
        @props.setSelectorContext(teamType, jamIndex, selectHandler)
      setSkater: (teamType, jamIndex, position, skaterIndex) ->
        box = @getPenaltyBoxState(teamType, jamIndex, position)
        skater = @getSkaterState(teamType, skaterIndex).skater
        box.skater = skater
        @setState(@state)
  componentDidMount: () ->
    $dom = $(@getDOMNode())
  bindActions: (teamType) ->
    Object.keys(@actions).map((key) ->
      key: key
      value: @actions[key].bind(this, teamType)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  render: () ->
    homeElement = <TeamPenaltyTimers teamState={@state.gameState.homeAttributes} jamNumber={@state.gameState.jamNumber} actions={@bindActions('home')}/>
    awayElement = <TeamPenaltyTimers teamState={@state.gameState.awayAttributes} jamNumber={@state.gameState.jamNumber} actions={@bindActions('away')}/>
    <div className="penalty-box-timer">
      <GameClockSummary gameState={@state.gameState} />
      <TeamSelector
        awayAttributes={@state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={@state.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>

