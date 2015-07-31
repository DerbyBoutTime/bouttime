React = require 'react/addons'
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
        {@props.team.seats.map (seat) ->
          <PenaltyClock key={seat.id}
            {...@props}
            entry={seat} />
        , this}
      </section>
    </div>