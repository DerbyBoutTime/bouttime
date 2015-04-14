React = require 'react/addons'
$ = require 'jquery'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
constants = require '../constants.coffee'
{ActionTypes} = require '../constants.coffee'
functions = require '../functions.coffee'
CountdownClock = require '../clock.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamTimer'
  getInitialState: () ->
    modalHandler: () ->
  handleToggleTimeoutBar: (evt) ->
    $target = $(evt.target)
    $parent = $target.closest(".timeout-bars").first()
    if $target.hasClass "official-review"
      if $target.hasClass "inactive"
        #Set has official review to true
        #Increment official reviews retained
        if $parent.hasClass "home"
          AppDispatcher.dispatchAndEmit
            type: ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
        else
          AppDispatcher.dispatchAndEmit
            type: ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
      else
        #Set has official review to false
        if $parent.hasClass "home"
          AppDispatcher.dispatchAndEmit
            type: ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
        else
          AppDispatcher.dispatchAndEmit
            type: ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
    else #Its a normal timeout not an official review
      timeoutsRemaining = 0
      if $target.hasClass "inactive"
        timeoutsRemaining = timeoutsRemaining + 1
      timeoutsRemaining = timeoutsRemaining + $target.nextAll(".bar").length
      console.log "Setting remaining timeouts to #{timeoutsRemaining}"
      #Set remaining timeouts
      if $parent.hasClass "home"
        AppDispatcher.dispatchAndEmit
          type: ActionTypes.SET_HOME_TEAM_TIMEOUTS
          timoutsRemaining: timeoutsRemaining
      else
        AppDispatcher.dispatchAndEmit
          type: ActionTypes.SET_AWAY_TEAM_TIMEOUTS
          timeoutsRemaining: timeoutsRemaining
    return null
  openModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $modal.modal('show')
  handleModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $input = $(@refs.modalInput.getDOMNode())
    $modal.modal('hide')
    val = parseInt($input.val())
    @state.modalHandler(val)
  clickJamEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.gameState.jamNumber)
    @openModal()
    @setState
      modalHandler: @setJamNumber
  clickPeriodEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.gameState.periodNumber)
    @openModal()
    @setState
      modalHandler: @setPeriodNumber
  clickJamClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.gameState.jamClock.time/1000)
    @openModal()
    @setState
      modalHandler: @setJamClock
  clickPeriodClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.gameState.periodClock.time/1000)
    @openModal()
    @setState
      modalHandler: @setPeriodClock
  startClock: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_CLOCK
      gameId: @props.gameState.id
  stopClock: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.STOP_CLOCK
      gameId: @props.gameState.id
  startJam: () ->
    console.log(this)
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_JAM
      gameId: @props.gameState.id
  stopJam: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.STOP_JAM
      gameId: @props.gameState.id
  startLineup: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_LINEUP
      gameId: @props.gameState.id
  startPregame: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_PREGAME
      gameId: @props.gameState.id
  startHalftime: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_HALFTIME
      gameId: @props.gameState.id
  startUnofficialFinal: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_UNOFFICIAL_FINAL
      gameId: @props.gameState.id
  startOfficialFinal: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_OFFICIAL_FINAL
      gameId: @props.gameState.id
  startTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_TIMEOUT
      gameId: @props.gameState.id
  setTimeoutAsOfficialTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_OFFICIAL_TIMEOUT
      gameId: @props.gameState.id
  setTimeoutAsHomeTeamTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_TIMEOUT
      gameId: @props.gameState.id
  setTimeoutAsHomeTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameState.id
  setTimeoutAsAwayTeamTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_TIMEOUT
      gameId: @props.gameState.id
  setTimeoutAsAwayTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameState.id
  setJamEndedByTime: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_ENDED_BY_TIME
      gameId: @props.gameState.id
  setJamEndedByCalloff: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_ENDED_BY_CALLOFF
      gameId: @props.gameState.id
  setJamClock: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_CLOCK
      gameId: @props.gameState.id
  setPeriodClock: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PERIOD_CLOCK
      gameId: @props.gameState.id
  setHomeTeamTimeouts: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_HOME_TEAM_TIMEOUTS
      gameId: @props.gameState.id
  setAwayTeamTimeouts: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_AWAY_TEAM_TIMEOUTS
      gameId: @props.gameState.id
  setPeriodNumber: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PERIOD_NUMBER
      gameId: @props.gameState.id
  setJamNumber: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_NUMBER
      gameId: @props.gameState.id
  removeHomeTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameState.id
  removeAwayTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameState.id
  restoreHomeTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameState.id
  restoreAwayTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameState.id
  render: () ->
    #CS = Class Set
    timeoutSectionCS = cx
      'timeout-section': true
      'row': true
      'margin-xs': true
      'hidden':  ["jam", "lineup", "timeout", "unofficial_final"].indexOf(@props.gameState.state) == -1
    timeoutExplanationSectionCS = cx
      'timeout-explanation-section': true
      'row': true
      'margin-xs': true
      'hidden': @props.gameState.state !="timeout"
    startClockSectionCS = cx
      'start-clock-section': true
      'row': true
      'margin-xs': true
      'hidden': ["pregame", "halftime", "final"].indexOf(@props.gameState.state) == -1
    stopClockSectionCS = cx
      'stop-clock-section': true
      'row': true
      'margin-xs': true
      'hidden': @props.gameState.state != ["pregame"]
    startJamSectionCS = cx
      'start-jam-section': true
      'row': true
      'margin-xs': true
      'hidden': ["pregame", "halftime", "lineup"].indexOf(@props.gameState.state) == -1
    stopJamSectionCS = cx
      'stop-jam-section': true
      'row': true
      'margin-xs': true
      'hidden': ["jam"].indexOf(@props.gameState.state) == -1
    startLineupSectionCS = cx
      'start-lineup-section': true
      'row': true
      'margin-xs': true
      'hidden': ["pregame", "halftime",  "timeout", "unofficial_final", "final"].indexOf(@props.gameState.state) == -1
    jamExplanationSectionCS = cx
      'jam-explanation-section': true
      'row': true
      'margin-xs': true
      'hidden': ["lineup", "timeout", "unofficial_final"].indexOf(@props.gameState.state) == -1
    homeTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @props.gameState.home.isTakingOfficialReview
      'inactive': @props.gameState.home.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': @props.gameState.home.isTakingTimeout && @props.gameState.home.timeouts == 2
      'inactive': @props.gameState.home.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': @props.gameState.home.isTakingTimeout && @props.gameState.home.timeouts == 1
      'inactive': @props.gameState.home.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': @props.gameState.home.isTakingTimeout && @props.gameState.home.timeouts == 0
      'inactive': @props.gameState.home.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @props.gameState.away.isTakingOfficialReview
      'inactive': @props.gameState.away.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': @props.gameState.away.isTakingTimeout && @props.gameState.away.timeouts == 2
      'inactive': @props.gameState.away.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': @props.gameState.away.isTakingTimeout && @props.gameState.away.timeouts == 1
      'inactive': @props.gameState.away.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': @props.gameState.away.isTakingTimeout && @props.gameState.away.timeouts == 0
      'inactive': @props.gameState.away.timeouts < 1
    <div className="jam-timer">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{@props.gameState.home.initials}</span>
              <div className={homeTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@props.gameState.home.officialReviewsRetained}</div>
              <div className={homeTeamTimeouts1CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={homeTeamTimeouts2CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={homeTeamTimeouts3CS} onClick={@handleToggleTimeoutBar}></div>
            </div>
          </div>
          <div className="col-md-8 col-xs-8">
            <div className="row">
              <div className="col-xs-12">
                <strong>
                  <span className="jt-label pull-left" onClick={@clickPeriodEdit}>
                    Period {@props.gameState.periodNumber}
                  </span>
                  <span className="jt-label pull-right" onClick={@clickJamEdit}>
                    Jam {@props.gameState.jamNumber}
                  </span>
                </strong>
              </div>
              <div className="col-md-12 col-xs-12">
                <div className="period-clock" onClick={@clickPeriodClockEdit}>{@props.gameState.periodClock.display()}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{@props.gameState.state.replace(/_/g, ' ')}</strong>
                <div className="jam-clock" onClick={@clickJamClockEdit}>{@props.gameState.jamClock.display()}</div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{@props.gameState.away.initials}</span>
              <div className={awayTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@props.gameState.away.officialReviewsRetained}</div>
              <div className={awayTeamTimeouts1CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={awayTeamTimeouts2CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={awayTeamTimeouts3CS} onClick={@handleToggleTimeoutBar}></div>
            </div>
          </div>
        </div>
        <div className={timeoutSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@startTimeout}>TIMEOUT</button>
          </div>
        </div>
        <div className={timeoutExplanationSectionCS}>
          <div className="col-xs-4">
            <div className="home">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@setTimeoutAsHomeTeamTimeout}>TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@setTimeoutAsHomeTeamOfficialReview}>
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-md-4 col-xs-4">
            <button className="bt-btn" onClick={@setTimeoutAsOfficialTimeout}>
              <div>OFFICIAL</div>
              <div>TIMEOUT</div>
            </button>
          </div>
          <div className="col-md-4 col-xs-4 timeouts">
            <div className="away">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@setTimeoutAsAwayTeamTimeout}>TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@setTimeoutAsAwayTeamOfficialReview}>
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className={startClockSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@startClock}>START CLOCK</button>
          </div>
        </div>
        <div className={stopClockSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@stopClock}>STOP CLOCK</button>
          </div>
        </div>
        <div className={startJamSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@startJam}>START JAM</button>
          </div>
        </div>
        <div className={stopJamSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@stopJam}>STOP JAM</button>
          </div>
        </div>
        <div className={startLineupSectionCS}>
          <div className="col-xs-12 start-lineup-section">
            <button className="bt-btn" onClick={@startLineup}>START LINEUP</button>
          </div>
        </div>
        <div className={jamExplanationSectionCS}>
          <div className="col-xs-6">
            <button className="bt-btn" onClick={@setJamEndedByCalloff}>
              JAM CALLED
            </button>
          </div>
          <div className="col-xs-6">
            <button className="bt-btn" onClick={@setJamEndedByTime}>
              ENDED BY TIME
            </button>
          </div>
        </div>
        <div className="modal" ref="modal">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">Edit</h4>
              </div>
              <div className="modal-body">
                <input type="number" className="form-control" ref="modalInput"/>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-primary" onClick={@handleModal}>Save changes</button>
              </div>
            </div>
          </div>
        </div>
    </div>