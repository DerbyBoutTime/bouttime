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
    boxState: React.PropTypes.object.isRequired
    boxIndex: React.PropTypes.number
    hidden: React.PropTypes.bool
  toggleLeftEarly: () ->
    return if not @props.boxIndex?
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_LEFT_EARLY
      teamId: @props.team.id
      boxIndex: @props.boxIndex
  toggleServed: () ->
    return if not @props.boxIndex?
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_PENALTY_SERVED
      teamId: @props.team.id
      boxIndex: @props.boxIndex
  setSkater: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PENALTY_BOX_SKATER
      teamId: @props.team.id
      boxIndexOrPosition: @props.boxIndex ? @props.boxState.position
      skaterId: skaterId
      clockId: functions.uniqueId()
  addPenaltyTime: () ->
    return if not @props.boxIndex?
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.ADD_PENALTY_TIME
      teamId: @props.team.id
      boxIndex: @props.boxIndex
  togglePenaltyTimer: () ->
    return if not @props.boxIndex?
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_PENALTY_TIMER
      teamId: @props.team.id
      boxIndex: @props.boxIndex 
  render: () ->
    teamStyle = @props.team.colorBarStyle
    placeholder = switch @props.boxState.position
      when 'jammer' then "J"
      when 'blocker' then "B"
    containerClass = cx
      'penalty-clock': true
      'hidden': @props.hidden
    leftEarlyButtonClass = cx
      'bt-btn': true
      'btn-warning': @props.boxState.leftEarly
    servedButtonClass = cx
      'bt-btn': true
      'btn-success': @props.boxState.served
    <div className={containerClass}>
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6">
          <div className="row gutters-xs">
            <div className="col-xs-6">
              <button className="bt-btn" onClick={@addPenaltyTime}>+30</button>
            </div>
            <div className="col-xs-6">
              <SkaterSelector
                skater={@props.boxState.skater}
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
          <div className="penalty-count bt-box box-primary">{@props.boxState.penaltyCount}</div>
          <button className="bt-btn btn-default clock" id={@clockId} onClick={@togglePenaltyTimer}>{@props.boxState.clock.display()}</button>
        </div>
      </div>
    </div>