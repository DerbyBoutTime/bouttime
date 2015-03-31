cx = React.addons.classSet
exports = exports ? this
exports.PenaltyBoxTimer = React.createClass
  displayName: 'PenaltyBoxTimer'
  mixins: [GameStateMixin, CopyGameStateMixin]
  componentWillMount: () ->
    @actions =
      toggleLeftEarly: (teamType, boxIndex) ->
        box = @getPenaltyBoxState(teamType, boxIndex)
        if box?
          box.leftEarly = !box.leftEarly
          box.served = false
          @setState(@state)
      toggleServed: (teamType, boxIndex) ->
        box = @getPenaltyBoxState(teamType, boxIndex)
        if box?
          box.served = !box.served
          box.leftEarly = false
          @setState(@state)
      setSelectorContext: (teamType, jamIndex, selectHandler) ->
        @props.setSelectorContext(teamType, jamIndex, selectHandler)
      setSkater: (teamType, boxIndexOrPosition, skaterIndex) ->
        box = @actions.getOrCreatePenaltyBoxState.call(this, teamType, boxIndexOrPosition)
        skater = @getSkaterState(teamType, skaterIndex).skater
        box.skater = skater
        @setState(@state)
      newPenaltyBoxState: (teamType, position) ->
        position: position
      getOrCreatePenaltyBoxState: (teamType, boxIndexOrPosition) ->
        switch typeof boxIndexOrPosition
          when 'number'
            @getPenaltyBoxState(teamType, boxIndexOrPosition)
          when 'string'
            box = @actions.newPenaltyBoxState.call(this, teamType, boxIndexOrPosition)
            @getTeamState(teamType).penaltyBoxStates.push(box)
            @setState(@state)
            box

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

