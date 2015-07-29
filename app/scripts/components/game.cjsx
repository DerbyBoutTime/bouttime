React = require 'react/addons'
constants = require '../constants.coffee'
functions = require '../functions.coffee'
Titlebar = require './titlebar.cjsx'
Navbar = require './navbar.cjsx'
JamTimer = require './jam_timer.cjsx'
LineupTracker = require './lineup_tracker.cjsx'
Scorekeeper = require './scorekeeper.cjsx'
PenaltyTracker = require './penalty_tracker.cjsx'
PenaltyBoxTimer = require './penalty_box_timer.cjsx'
Scoreboard = require './scoreboard.cjsx'
PenaltyWhiteboard = require './penalty_whiteboard.cjsx'
AnnouncersFeed = require './announcers_feed.cjsx'
GameNotes = require './game_notes.cjsx'
GameSetup = require './game_setup.cjsx'
Login = require './login.cjsx'
SkaterSelectorModal = require './shared/skater_selector_modal.cjsx'
{ClockManager} = require '../clock.coffee'
GameState = require '../models/game_state.coffee'
AppDispatcher = require '../dispatcher/app_dispatcher'
qs = require 'querystring'
cx = React.addons.classSet
window.Perf = React.addons.Perf
module.exports = React.createClass
  displayName: 'Game'
  componentDidMount: () ->
    GameState.addChangeListener @onChange
  componentWillUnmount: () ->
    GameState.removeChangeListener @onChange
  setTab: (tab) ->
    if tab isnt @state.tab
      @setState tab: tab
      window.history.pushState('', window.title, @getFragment(@props.gameStateId, tab))
  resetDeadmanTimer: () ->
    clearTimeout(exports.connectionTimeout)
    @gameDOM.addClass("connected")
    exports.connectionTimeout = setInterval(() =>
      @gameDOM.removeClass("connected")
    , constants.CLOCK_REFRESH_RATE_IN_MS*2)
  loadGameState: () ->
    if @props.gameState?.id isnt @props.gameStateId
      window.history.pushState('', window.title, @getFragment(@props.gameStateId, @parseTab()))
    GameState.find(@props.gameStateId).then (gs) =>
      AppDispatcher.syncGame(@props.gameStateId) if not gs?
      gs
  onChange: () ->
    @loadGameState().then (gs) =>
      @setState gameState: gs
  parseTab: () ->
    qs.parse(window?.location?.hash?.substring(1)).tab ? 'jam_timer'
  getFragment: (id, tab) ->
    "#" + 
    qs.stringify
      id: id
      tab: tab
  getInitialState: () ->
    gameState = @loadGameState()
    gameState: null
    tab: @parseTab()
    skaterSelectorContext: null
  setSelectorContext: (team, jam, selectHandler) ->
    @setState
      skaterSelectorContext:
        team: team
        jam: jam
        selectHandler: selectHandler
  defaultTab: () ->
    @setState tab: 'jam_timer'
  render: () ->
    if not @state.gameState?
      return <span>Loading</span>
    tab = switch @state.tab
      when "jam_timer"
        home =
          officialReviewsRetained: @state.gameState.home.officialReviewsRetained
          hasOfficialReview: @state.gameState.home.hasOfficialReview
          isTakingOfficialReview: @state.gameState.home.isTakingOfficialReview
          timeouts: @state.gameState.home.timeouts
          initials: @state.gameState.home.initials
          isTakingTimeout: @state.gameState.home.isTakingTimeout
          colorBarStyle: @state.gameState.home.colorBarStyle
        away =
          officialReviewsRetained: @state.gameState.away.officialReviewsRetained
          hasOfficialReview: @state.gameState.away.hasOfficialReview
          isTakingOfficialReview: @state.gameState.away.isTakingOfficialReview
          timeouts: @state.gameState.away.timeouts
          initials: @state.gameState.away.initials
          isTakingTimeout: @state.gameState.away.isTakingTimeout
          colorBarStyle: @state.gameState.away.colorBarStyle
        <JamTimer
          periodClock={@state.gameState.periodClock}
          jamClock={@state.gameState.jamClock}
          jamNumber={@state.gameState.jamNumber}
          period={@state.gameState.period}
          gameStateId={@state.gameState.id}
          state={@state.gameState.state}
          isUndoable={@state.gameState.isUndoable()}
          isRedoable={@state.gameState.isRedoable()}
          home={home}
          away={away}/>
      when "lineup_tracker"
        <LineupTracker gameState={@state.gameState} />
      when "scorekeeper"
        <Scorekeeper gameState={@state.gameState} setSelectorContext={@setSelectorContext} />
      when "penalty_tracker"
        <PenaltyTracker gameState={@state.gameState} />
      when "penalty_box_timer"
        <PenaltyBoxTimer gameState={@state.gameState} setSelectorContext={@setSelectorContext}/>
      when "scoreboard"
        <Scoreboard gameState={@state.gameState}/>
      when "penalty_whiteboard"
        <PenaltyWhiteboard {...@state} />
      when "announcers_feed"
        <AnnouncersFeed gameState={@state.gameState} />
      when "game_notes"
        <GameNotes gameState={@state.gameState} />
      when "game_setup"
        <GameSetup ref="gameSetup" gameState={@state.gameState} onSave={@defaultTab} />
      when "login"
        <Login />
    <div ref="game" className="game" data-tab={@state.tab}>
      <header>
        <div className="container-fluid">
          <Titlebar gameName={@state.gameState.getDisplayName()} tabHandler={@setTab} backHandler={@props.backHandler}/>
          <div className="logo">
            <div className="container">
              <a href="#">
                <img className="hidden-xs" height="64" src="/images/logo.png" />
                <img className="visible-xs-block" height="48" src="/images/logo.png" />
              </a>
            </div>
          </div>
          <Navbar tab={@state.tab} tabHandler={@setTab}/>
        </div>
      </header>
      <div className="container">
        {tab}
      </div>
      <SkaterSelectorModal {...@state.skaterSelectorContext} />
    </div>
