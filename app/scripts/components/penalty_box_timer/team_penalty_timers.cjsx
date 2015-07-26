React = require 'react/addons'
{ClockManager} = require '../../clock'
PenaltyClock = require './penalty_clock'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamPenaltyTimers'
  propTypes:
    team: React.PropTypes.object.isRequired
    jamNumber: React.PropTypes.number.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  componentWillMount: () ->
    @clockManager = new ClockManager()
    @jammerBoxState = @props.team.newPenaltyBoxState('jammer')
    @blockerBoxState = @props.team.newPenaltyBoxState('blocker')
  componentDidMount: () ->
    @clockManager.addTickListener @onTick
  componentWillUnmount: () ->
    @clockManager.removeTickListener @onTick
    @clockManager.removeClock(@jammerBoxState.clock.alias)
    @clockManager.removeClock(@blockerBoxState.clock.alias)
  onTick: () ->
    @forceUpdate()
  getInitialState: () ->
    state: "Start All"
  toggleAllPenaltyTimers: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_ALL_PENALTY_TIMERS
      teamId: @props.team.id
  render: () ->
    anyRunning = @props.team.anyPenaltyTimerRunning()
    playPauseCS = cx({
      'glyphicon' : true
      'glyphicon-play' : not anyRunning
      'glyphicon-pause' : anyRunning
    })
    hideJammer = @props.team.penaltyBoxStates.some (boxState) ->
      boxState.position is 'jammer' and not boxState.served
    numBlockersServing = @props.team.penaltyBoxStates.filter((boxState) -> boxState.position is 'blocker' and not boxState.served).length
    visibleBlockers = 4 - numBlockersServing
    <div className="team-penalty-timers">
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6">
          <button className="bt-btn">
            <span>EDIT&nbsp;&nbsp;</span>
            <i className="glyphicon glyphicon-pencil"></i>
          </button>
        </div>
        <div className="col-xs-6">
          <button className="bt-btn" onClick={@toggleAllPenaltyTimers}>
            <span>{if anyRunning then "Stop All" else "Start All"}&nbsp;&nbsp;</span>
            <i className={playPauseCS}></i>
          </button>
        </div>
      </div>
      <section className="penalty-clocks">
        {@props.team.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock key={boxIndex}
            {...@props}
            boxState={boxState}
            boxIndex={boxIndex}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'jammer'
        , this}
        <PenaltyClock
          {...@props}
          boxState={@jammerBoxState}
          hidden={hideJammer}/>
        {@props.team.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock key={boxIndex}
            {...@props}
            boxState={boxState}
            boxIndex={boxIndex}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'blocker'
        , this}
        {[0...visibleBlockers].map (i) ->
          <PenaltyClock key={i}
            {...@props}
            boxState={@blockerBoxState}/>
        , this}
      </section>
    </div>