React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
PenaltyClock = require './penalty_clock.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamPenaltyTimers'
  propTypes:
    team: React.PropTypes.object.isRequired
    jamNumber: React.PropTypes.number.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  getInitialState: () ->
    state: "Start All"
  handleStartStopAll: () ->
    console.log "Start/stop all"
    if @state.state is "Start All"
      [0..4].map (i) =>
        clock = @refs["clocks#{i}"]
        if clock.hasSkater()
          clock.start()
      @setState
        state: "Stop All"
    else
      [0..4].map (i) =>
        clock = @refs["clocks#{i}"]
        clock.stop()
      @setState
        state: "Start All"
  toggleLeftEarly: (boxIndex) ->
    AppDispatcher.dispatch
      type: ActionTypes.TOGGLE_LEFT_EARLY
      teamId: @props.team.id
      boxIndex: boxIndex
  toggleServed: (boxIndex) ->
    AppDispatcher.dispatch
      type: ActionTypes.TOGGLE_PENALTY_SERVED
      teamId: @props.team.id
      boxIndex: boxIndex
  setSkater: (boxIndexOrPosition, skaterId) ->
    AppDispatcher.dispatch
      type: ActionTypes.SET_PENALTY_BOX_SKATER
      teamId: @props.team.id
      boxIndexOrPosition: boxIndexOrPosition
      skaterId: skaterId
  render: () ->
    playPauseCS = cx({
      'glyphicon' : true
      'glyphicon-play' : @state.state == "Start All"
      'glyphicon-pause' : @state.state == "Stop All"
    })
    hideJammer = @props.team.penaltyBoxStates.some (boxState) ->
      boxState.position is 'jammer' and not boxState.served
    numBlockersServing = @props.team.penaltyBoxStates.filter((boxState) -> boxState.position is 'blocker' and not boxState.served).length
    visibleBlockers = 4 - numBlockersServing
    <div className="team-penalty-timers">
      <div className="row gutters-xs">
        <div className="col-xs-6">
          <button className="bt-btn edit-btn">
            <span>EDIT</span>
            <i className="glyphicon glyphicon-pencil"></i>
          </button>
        </div>
        <div className="col-xs-6">
          <button className="bt-btn all-clocks-btn" onClick={@handleStartStopAll}>
            <span>{@state.state}&nbsp;&nbsp;</span>
            <i className={playPauseCS}></i>
          </button>
        </div>
      </div>
      <section className="penalty-clocks">
        {@props.team.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock ref="clocks0" key={boxIndex}
            teamStyle={@props.team.colorBarStyle}
            boxState={boxState}
            toggleLeftEarly={@toggleLeftEarly.bind(this, boxIndex)}
            toggleServed={@toggleServed.bind(this, boxIndex)}
            setSkater={@setSkater.bind(this, boxIndex)}
            setSelectorContext={@props.setSelectorContext}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'jammer'
        , this}
        <PenaltyClock ref="clocks0"
          teamStyle={@props.team.colorBarStyle}
          boxState={position: 'jammer'}
          toggleLeftEarly={@toggleLeftEarly.bind(this, null)}
          toggleServed={@toggleServed.bind(this, null)}
          setSelectorContext={@props.setSelectorContext}
          setSkater={@setSkater.bind(this, 'jammer')}
          hidden={hideJammer}/>
        {@props.team.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock ref="clocks#{boxIndex}" key={boxIndex}
            teamStyle={@props.team.colorBarStyle}
            boxState={boxState}
            toggleLeftEarly={@toggleLeftEarly.bind(this, boxIndex)}
            toggleServed={@toggleServed.bind(this, boxIndex)}
            setSkater={@setSkater.bind(this, boxIndex)}
            setSelectorContext={@props.setSelectorContext}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'blocker'
        , this}
        {[0...visibleBlockers].map (i) ->
          <PenaltyClock ref="clocks#{numBlockersServing+i+1}" key={i}
            teamStyle={@props.team.colorBarStyle}
            boxState={position: 'blocker'}
            toggleLeftEarly={@toggleLeftEarly.bind(this, null)}
            toggleServed={@toggleServed.bind(this, null)}
            setSkater={@setSkater.bind(this, 'blocker')} 
            setSelectorContext={@props.setSelectorContext}/>
        , this}
      </section>
    </div>