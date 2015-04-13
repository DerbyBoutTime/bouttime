React = require 'react/addons'
PenaltyClock = require './penalty_clock.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamPenaltyTimers'
  propTypes:
    team: React.PropTypes.object.isRequired
    jamNumber: React.PropTypes.number.isRequired
    actions: React.PropTypes.object.isRequired
  bindActions: (boxIndex) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, boxIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
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

  render: () ->
    playPauseCS = cx({
      'glyphicon' : true
      'glyphicon-play' : @state.state == "Start All"
      'glyphicon-pause' : @state.state == "Stop All"
    })
    jamIndex = Math.max(@props.jamNumber - 1, 0)
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
            boxState={boxState} actions={@bindActions(boxIndex)}
            setSelectorContext={@props.actions.setSelectorContext.bind(this, jamIndex)}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'jammer'
        , this}
        <PenaltyClock ref="clocks0"
          teamStyle={@props.team.colorBarStyle}
          boxState={position: 'jammer'}
          actions={@bindActions('jammer')}
          setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}
          hidden={hideJammer}/>
        {@props.team.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock ref="clocks#{boxIndex}" key={boxIndex}
            teamStyle={@props.team.colorBarStyle}
            boxState={boxState}
            actions={@bindActions(boxIndex)}
            setSelectorContext={@props.actions.setSelectorContext.bind(this, jamIndex)}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'blocker'
        , this}
        {[0...visibleBlockers].map (i) ->
          <PenaltyClock ref="clocks#{numBlockersServing+i+1}" key={i}
            teamStyle={@props.team.colorBarStyle}
            boxState={position: 'blocker'}
            actions={@bindActions('blocker')}
            setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}/>
        , this}
      </section>
    </div>