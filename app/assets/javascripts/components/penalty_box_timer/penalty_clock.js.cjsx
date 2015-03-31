cx = React.addons.classSet
exports = exports ? this
exports.PenaltyClock = React.createClass
  displayName: "PenaltyClock"
  getInitialState: () ->
    @clockId = exports.wftda.functions.uniqueId()
    clock: new exports.classes.CountdownClock
      time: exports.wftda.constants.PENALTY_DURATION_IN_MS
      warningTime: exports.wftda.constants.PENALTY_WARNING_IN_MS
      refreshRateInMs: exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS
      selector: "##{@clockId}"
  componentDidMount: () ->
    $("##{@clockId}").on 'tick', (evt) =>
      @forceUpdate()
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
        <SkaterSelector
          skater={@props.boxState.skater}
          style={@props.teamStyle}
          setSelectorContext={@props.setSelectorContext}
          selectHandler={@props.actions.setSkater}
          placeholder={placeholder}
          />
        <div className="skater-data">
          <button className={leftEarlyButtonClass} onClick={@props.actions.toggleLeftEarly}>
            <strong>Early</strong>
          </button>
          <button className={servedButtonClass} onClick={@props.actions.toggleServed}>
            <span className="glyphicon glyphicon-ok"></span>
          </button>
        </div>
      </div>
      <div className="col-xs-6">
        <button className="clock" id={@clockId} onClick={@clockHandler}>{@state.clock.display()}</button>
      </div>
    </div>