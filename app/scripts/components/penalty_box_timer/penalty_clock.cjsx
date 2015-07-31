React = require 'react/addons'
functions = require '../../functions.coffee'
{ClockManager} = require '../../clock.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: "PenaltyClock"
  propTypes:
    team: React.PropTypes.object.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
    entry: React.PropTypes.object.isRequired
  componentWillMount: () ->
    @clockManager = new ClockManager()
  componentDidMount: () ->
    @clockManager.addTickListener @onTick
  componentWillUnmount: () ->
    @clockManager.removeTickListener @onTick
  onTick: () ->
    @forceUpdate()
  toggleLeftEarly: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_LEFT_EARLY
      boxId: @props.entry.id
  toggleServed: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_PENALTY_SERVED
      boxId: @props.entry.id
  setSkater: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PENALTY_BOX_SKATER
      boxId: @props.entry.id
      skaterId: skaterId
  togglePenaltyTimer: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_PENALTY_TIMER
      boxId: @props.entry.id
  render: () ->
    teamStyle = @props.team.colorBarStyle
    placeholder = switch @props.entry.position
      when 'jammer' then "Jammer"
      when 'blocker' then "Blocker"
    containerClass = cx
      'penalty-clock': true
      'hidden': @props.hidden
    leftEarlyButtonClass = cx
      'bt-btn': true
      'btn-warning': @props.entry.leftEarly
    servedButtonClass = cx
      'bt-btn': true
      'btn-success': @props.entry.served
    <div className={containerClass}>
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6">
          <div className="row gutters-xs">
            <div className="col-xs-12">
              <SkaterSelector
                skater={@props.entry.skater}
                style={teamStyle}
                setSelectorContext={@props.setSelectorContext}
                selectHandler={@setSkater}
                placeholder={placeholder}
                />
            </div>
          </div>
          <div className="row gutters-xs top-buffer">
            <div className="col-xs-6">
              <button className={leftEarlyButtonClass} onClick={@toggleLeftEarly}>
                <strong>Early</strong>
              </button>
            </div>
            <div className="col-xs-6">
              <button className={servedButtonClass} onClick={@toggleServed}>
                <span className="glyphicon glyphicon-ok"></span>
              </button>
            </div>
          </div>
        </div>
        <div className="col-xs-6">
          <button className="bt-btn btn-default clock" id={@clockId} onClick={@togglePenaltyTimer}>{@props.entry.clock.display()}</button>
        </div>
      </div>
    </div>