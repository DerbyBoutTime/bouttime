React = require 'react/addons'
constants = require '../../constants.coffee'
functions = require '../../functions.coffee'
CountdownClock = require '../../clock.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: "PenaltyClock"
  getInitialState: () ->
    @clockId = functions.uniqueId()
    h =
      penaltyCount: 1
      clock: new CountdownClock
        time: constants.PENALTY_DURATION_IN_MS
        warningTime: constants.PENALTY_WARNING_IN_MS
        refreshRateInMs: constants.CLOCK_REFRESH_RATE_IN_MS
        selector: "##{@clockId}"
  componentDidMount: () ->
    $("##{@clockId}").on 'tick', (evt) =>
      @forceUpdate()
  addPenalty: () ->
    @state.penaltyCount = @state.penaltyCount + 1
    @state.clock.time = @state.clock.time + constants.PENALTY_DURATION_IN_MS
    @forceUpdate()
  start: () ->
    @state.clock.start()
  stop: () ->
    @state.clock.stop()
  hasSkater: () ->
    !!@props.boxState.skater
  clockHandler: () ->
    if @state.clock.time is 0
      @state.clock.reset()
    else if @state.clock.isRunning()
      @state.clock.stop()
    else
      @state.clock.start()
    @forceUpdate()
  render: () ->
    placeholder = switch @props.boxState.position
      when 'jammer' then "Jammer"
      when 'blocker' then "Blocker"
    containerClass = cx
      'penalty-clock': true
      'hidden': @props.hidden
    leftEarlyButtonClass = cx
      'left-early-button': true
      'selected': @props.boxState.leftEarly
    servedButtonClass = cx
      'served-button': true
      'selected': @props.boxState.served
    <div className={containerClass}>
      <div className="skater-wrapper">
        <div className="col-xs-6">
          <button className="bt-btn" onClick={@addPenalty}>+30</button>
        </div>
        <div className="col-xs-6">
          <SkaterSelector
            skater={@props.boxState.skater}
            style={@props.teamStyle}
            setSelectorContext={@props.setSelectorContext}
            selectHandler={@props.setSkater}
            placeholder={placeholder}
            />
        </div>
        <div className="skater-data">
          <button className={leftEarlyButtonClass} onClick={@props.toggleLeftEarly}>
            <strong>Early</strong>
          </button>
          <button className={servedButtonClass} onClick={@props.toggleServed}>
            <span className="glyphicon glyphicon-ok"></span>
          </button>
        </div>
      </div>
      <div className="col-xs-6">
        <div className="penalty-count">{@state.penaltyCount}</div>
        <button className="clock" id={@clockId} onClick={@clockHandler}>{@state.clock.display()}</button>
      </div>
    </div>