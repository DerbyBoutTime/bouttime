React = require 'react/addons'
$ = require 'jquery'
AppDispatcher = require '../dispatcher/app_dispatcher.coffee'
constants = require '../constants.coffee'
{ActionTypes} = require '../constants.coffee'
functions = require '../functions.coffee'
PeriodSummary = require './shared/period_summary'
JamSummary = require './shared/jam_summary'
ShortcutButton = require './shared/shortcut_button'
Clocks = require '../clock.coffee'
TimeoutBars = require './jam_timer/timeout_bars.cjsx'
shallowEqual = require '../shallowEqual.js'
_ = require 'underscore'
window._ = _
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamTimer'
  propTypes:
    periodClock: React.PropTypes.instanceOf(Clocks.Clock)
    jamClock: React.PropTypes.instanceOf(Clocks.Clock)
    jamNumber: React.PropTypes.number
    gameStateId: React.PropTypes.string
    state: React.PropTypes.oneOf ["jam", "lineup", "timeout", "pregame", "halftime", "unofficial final", "official final", "overtime"]
    period: React.PropTypes.oneOf ["pregame", "period 1", "period 2", "halftime", "unofficial final", "official final"]
    home: React.PropTypes.shape
      hasOfficialReview: React.PropTypes.bool
      officialReviewsRetained: React.PropTypes.number
      isTakingOfficialReview: React.PropTypes.bool
      isTakingTimeout: React.PropTypes.bool
      timeouts: React.PropTypes.number
      initials: React.PropTypes.string
      colorBarStyle: React.PropTypes.object
    away: React.PropTypes.shape
      hasOfficialReview: React.PropTypes.bool
      officialReviewsRetained: React.PropTypes.number
      isTakingOfficialReview: React.PropTypes.bool
      isTakingTimeout: React.PropTypes.bool
      timeouts: React.PropTypes.number
      initials: React.PropTypes.string
      colorBarStyle: React.PropTypes.object
  getInitialState: () ->
    modalHandler: () ->
  shouldComponentUpdate: (nprops, nstate) ->
    not _.isEqual(@props, nprops) or not _.isEqual(@state, nstate)
  componentDidMount: () ->
    @props.jamClock.emitter.addListener "clockExpiration", @jamClockExpired
  componentWillUnmount: () ->
    @props.jamClock.emitter.removeListener "clockExpiration", @jamClockExpired
  jamClockExpired: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.HANDLE_CLOCK_EXPIRATION
      gameId: @props.gameStateId
  handleToggleTimeoutBar: (evt) ->
    $target = $(evt.target)
    $parent = $target.closest(".timeout-bars").first()
    if $target.hasClass "official-review"
      if $target.hasClass "inactive"
        #Set has official review to true
        #Increment official reviews retained
        if $parent.hasClass "home"
          @restoreHomeTeamOfficialReview()
        else
          @restoreAwayTeamOfficialReview()
      else
        #Set has official review to false
        if $parent.hasClass "home"
          @removeHomeTeamOfficialReview()
        else
          @removeAwayTeamOfficialReview()
    else #Its a normal timeout not an official review
      timeoutsRemaining = 0
      if $target.hasClass "inactive"
        timeoutsRemaining = timeoutsRemaining + 1
      timeoutsRemaining = timeoutsRemaining + $target.nextAll(".bar").length
      #Set remaining timeouts
      if $parent.hasClass "home"
        @setHomeTeamTimeouts(timeoutsRemaining)
      else
        @setAwayTeamTimeouts(timeoutsRemaining)
    return null
  openModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $modal.modal('show')
  handleModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $input = $(@refs[@state.modalInput].getDOMNode())
    $modal.modal('hide')
    val = $input.val()
    val = parseInt(val) if $input.attr('type') is 'number'
    @state.modalHandler(val)
  clickJamEdit: () ->
    $input = $(@refs.modalInputNumber.getDOMNode())
    $input.val(@props.jamNumber)
    @openModal()
    @setState
      modalInput: 'modalInputNumber'
      modalHandler: @setJamNumber
  clickPeriodEdit: () ->
    $input = $(@refs.modalPeriodSelect.getDOMNode())
    $input.val(@props.period)
    @openModal()
    @setState
      modalInput: 'modalPeriodSelect'
      modalHandler: @setPeriod
  clickJamClockEdit: () ->
    $input = $(@refs.modalInputText.getDOMNode())
    $input.val(@props.jamClock.display())
    @openModal()
    @setState
      modalInput: 'modalInputText'
      modalHandler: @setJamClock
  clickPeriodClockEdit: () ->
    $input = $(@refs.modalInputText.getDOMNode())
    $input.val(@props.periodClock.display())
    @openModal()
    @setState
      modalInput: 'modalInputText'
      modalHandler: @setPeriodClock
  startClock: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_CLOCK
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  stopClock: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.STOP_CLOCK
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startJam: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_JAM
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  stopJam: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.STOP_JAM
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startLineup: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_LINEUP
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startPregame: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_PREGAME
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startHalftime: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_HALFTIME
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startUnofficialFinal: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_UNOFFICIAL_FINAL
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startOfficialFinal: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_OFFICIAL_FINAL
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startOvertime: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_OVERTIME
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  startTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.START_TIMEOUT
      gameId: @props.gameStateId
      jamClock: @props.jamClock
      periodClock: @props.periodClock
      sourceDelay: AppDispatcher.delay
  setTimeoutAsOfficialTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_OFFICIAL_TIMEOUT
      gameId: @props.gameStateId
  setTimeoutAsHomeTeamTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_TIMEOUT
      gameId: @props.gameStateId
  setTimeoutAsHomeTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_HOME_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameStateId
  setTimeoutAsAwayTeamTimeout: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_TIMEOUT
      gameId: @props.gameStateId
  setTimeoutAsAwayTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_TIMEOUT_AS_AWAY_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameStateId
  setJamEndedByTime: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_ENDED_BY_TIME
      gameId: @props.gameStateId
  setJamEndedByCalloff: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_ENDED_BY_CALLOFF
      gameId: @props.gameStateId
  setJamClock: (value) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_CLOCK
      gameId: @props.gameStateId
      value: value
  setPeriodClock: (value) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PERIOD_CLOCK
      gameId: @props.gameStateId
      value: value
  setHomeTeamTimeouts: (value) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_HOME_TEAM_TIMEOUTS
      gameId: @props.gameStateId
      value: value
  setAwayTeamTimeouts: (value) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_AWAY_TEAM_TIMEOUTS
      gameId: @props.gameStateId
      value: value
  setPeriod: (value) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PERIOD
      gameId: @props.gameStateId
      value: value
  setJamNumber: (value) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_JAM_NUMBER
      gameId: @props.gameStateId
      value: value
  removeHomeTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_HOME_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameStateId
  removeAwayTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_AWAY_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameStateId
  restoreHomeTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.RESTORE_HOME_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameStateId
  restoreAwayTeamOfficialReview: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.RESTORE_AWAY_TEAM_OFFICIAL_REVIEW
      gameId: @props.gameStateId
  undo: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.JAM_TIMER_UNDO
      gameId: @props.gameStateId
  redo: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.JAM_TIMER_REDO
      gameId: @props.gameStateId
  modalInputClass: (ref) ->
    cx
      'form-control': true
      'hidden': @state.modalInput isnt ref
  render: () ->
    buttons = []
    if @props.state in ["jam", "lineup", "unofficial final", "overtime"]
      buttons.push <ShortcutButton className='bt-btn' onClick={@startTimeout} shortcut='t'>TIMEOUT</ShortcutButton>
    if @props.state in ["pregame", "halftime", "unofficial final", "official final"]
      buttons.push <ShortcutButton className='bt-btn' onClick={@startClock} shortcut='c'>START CLOCK</ShortcutButton>
    if @props.state in ["pregame", "halftime", "unofficial final", "official final"]
      buttons.push <ShortcutButton className="bt-btn" onClick={@stopClock} shortcut='C'>STOP CLOCK</ShortcutButton>
    if @props.state in ["pregame", "halftime", "lineup", "timeout", "overtime"]
      buttons.push <ShortcutButton className="bt-btn" onClick={@startJam} shortcut='j'>START JAM</ShortcutButton>
    if @props.state is "jam"
      buttons.push <ShortcutButton className="bt-btn" onClick={@stopJam} shortcut='J'>STOP JAM</ShortcutButton>
    if @props.state in ["pregame", "halftime", "timeout"]
      buttons.push <ShortcutButton className="bt-btn" onClick={@startLineup} shortcut='l'>START LINEUP</ShortcutButton>
    if @props.state is "lineup" and @props.period is "period 1" and @props.periodClock.time is 0
      buttons.push <ShortcutButton className="bt-btn" onClick={@startHalftime} shortcut='h'>START HALFTIME</ShortcutButton>
    if @props.state in ["lineup", "overtime"] and @props.period is "period 2" and @props.periodClock.time is 0
      buttons.push <ShortcutButton className="bt-btn" onClick={@startUnofficialFinal} shortcut='u'>START UNOFFICIAL FINAL</ShortcutButton>
      buttons.push <ShortcutButton className="bt-btn" onClick={@startOvertime} shortcut='o'>START OVERTIME</ShortcutButton>
    if @props.state is "unofficial final"
      buttons.push <ShortcutButton className="bt-btn" onClick={@startOfficialFinal} shortcut='o'>START OFFICIAL FINAL</ShortcutButton>
    if @props.isUndoable
      buttons.push <ShortcutButton className='bt-btn' onClick={@undo} shortcut='mod+z'>UNDO</ShortcutButton>
    if @props.isRedoable
      buttons.push <ShortcutButton className='bt-btn' onClick={@redo} shortcut='mod+shift+z'>REDO</ShortcutButton>
    timeoutExplanation =
      if @props.state =="timeout"
        <div className="timeout-explanation-section row margin-xs">
          <div className="col-xs-4">
            <div className="home">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <ShortcutButton className="bt-btn" onClick={@setTimeoutAsHomeTeamTimeout} style={@props.home.colorBarStyle} shortcut='h'>TIMEOUT</ShortcutButton>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <ShortcutButton className="bt-btn" onClick={@setTimeoutAsHomeTeamOfficialReview} style={@props.home.colorBarStyle} shortcut='H'>
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </ShortcutButton>
                </div>
              </div>
            </div>
          </div>
          <div className="col-md-4 col-xs-4">
            <ShortcutButton className="bt-btn" onClick={@setTimeoutAsOfficialTimeout} shortcut='o'>OFFICIAL<br/>TIMEOUT</ShortcutButton>
          </div>
          <div className="col-md-4 col-xs-4 timeouts">
            <div className="away">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <ShortcutButton className="bt-btn" onClick={@setTimeoutAsAwayTeamTimeout} style={@props.away.colorBarStyle} shortcut='a'>TIMEOUT</ShortcutButton>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <ShortcutButton className="bt-btn" onClick={@setTimeoutAsAwayTeamOfficialReview} style={@props.away.colorBarStyle} shortcut='A'>
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </ShortcutButton>
                </div>
              </div>
            </div>
          </div>
        </div>
    homeTeamTimeoutClasses = [
      cx
        'official-review': true
        'bar': true
        'clickable': true
        'active': @props.home.isTakingOfficialReview
        'inactive': @props.home.hasOfficialReview == false
      cx
        'bar': true
        'clickable': true
        'active': @props.home.isTakingTimeout && @props.home.timeouts == 2
        'inactive': @props.home.timeouts < 3
      cx
        'bar': true
        'clickable': true
        'active': @props.home.isTakingTimeout && @props.home.timeouts == 1
        'inactive': @props.home.timeouts < 2
      cx
        'bar': true
        'clickable': true
        'active': @props.home.isTakingTimeout && @props.home.timeouts == 0
        'inactive': @props.home.timeouts < 1
    ]
    awayTeamTimeoutClasses = [
      cx
        'official-review': true
        'bar': true
        'clickable': true
        'active': @props.away.isTakingOfficialReview
        'inactive': @props.away.hasOfficialReview == false
      cx
        'bar': true
        'clickable': true
        'active': @props.away.isTakingTimeout && @props.away.timeouts == 2
        'inactive': @props.away.timeouts < 3
      cx
        'bar': true
        'clickable': true
        'active': @props.away.isTakingTimeout && @props.away.timeouts == 1
        'inactive': @props.away.timeouts < 2
      cx
        'bar': true
        'clickable': true
        'active': @props.away.isTakingTimeout && @props.away.timeouts == 0
        'inactive': @props.away.timeouts < 1
    ]
    <div className="jam-timer">
      <div className="row text-center">
        <div className="col-md-2 col-xs-2">
          <TimeoutBars
            homeOrAway="home"
            initials={@props.home.initials}
            classSets={homeTeamTimeoutClasses}
            style={@props.home.colorBarStyle}
            reviewsRetained={@props.home.officialReviewsRetained}
            handleToggleTimeoutBar={@handleToggleTimeoutBar}
          />
        </div>
        <div className="col-md-8 col-xs-8">
          <PeriodSummary
            period={@props.period}
            jamNumber={@props.jamNumber}
            clickJam={@clickJamEdit}
            clickPeriod={@clickPeriodEdit}
            clickClock={@clickPeriodClockEdit}
            clock={@props.periodClock} />
          <JamSummary
            state={@props.state}
            clickClock={@clickJamClockEdit}
            clock={@props.jamClock} />
        </div>
        <div className="col-md-2 col-xs-2">
          <TimeoutBars
            homeOrAway="away"
            initials={@props.away.initials}
            classSets=awayTeamTimeoutClasses
            style={@props.away.colorBarStyle}
            reviewsRetained={@props.away.officialReviewsRetained}
            handleToggleTimeoutBar={@handleToggleTimeoutBar}
          />
        </div>
      </div>
      {timeoutExplanation}
      {buttons.map (button) ->
        <div key={button.props.children} className='row margin-xs'>
          <div className='col-xs-12'>
            {button}
          </div>
        </div>
      , this}
      <div className="modal" ref="modal">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
              <h4 className="modal-title">Edit</h4>
            </div>
            <div className="modal-body">
              <select className={@modalInputClass('modalPeriodSelect')} ref="modalPeriodSelect">
                <option value="pregame">Pregame</option>
                <option value="period 1">Period 1</option>
                <option value="halftime">Halftime</option>
                <option value="period 2">Period 2</option>
                <option value="unofficial final">Unofficial Final</option>
                <option value="official final">Official Final</option>
              </select>
              <input type="number" className={@modalInputClass('modalInputNumber')} ref="modalInputNumber"/>
              <input type="text" className={@modalInputClass('modalInputText')} ref="modalInputText" />
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-primary" onClick={@handleModal}>Save changes</button>
            </div>
          </div>
        </div>
      </div>
    </div>