React = require 'react/addons'
GameStateMixin = require '../mixins/game_state_mixin.cjsx'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
TeamPenaltyTimers = require './penalty_box_timer/team_penalty_timers.cjsx'
GameClockSummary = require './penalty_box_timer/game_clock_summary.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
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
        skater = @getSkater(teamType, skaterIndex)
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
            @getTeam(teamType).penaltyBoxStates.push(box)
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
    homeElement = <TeamPenaltyTimers team={@state.gameState.home} jamNumber={@state.gameState.jamNumber} actions={@bindActions('home')}/>
    awayElement = <TeamPenaltyTimers team={@state.gameState.away} jamNumber={@state.gameState.jamNumber} actions={@bindActions('away')}/>
    <div className="penalty-box-timer">
      <GameClockSummary gameState={@state.gameState} />
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={@state.gameState.home}
        homeElement={homeElement} />
    </div>

