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
Clocks = require '../clock.coffee'
GameState = require '../models/game_state.coffee'
cx = React.addons.classSet
window.Perf = React.addons.Perf
module.exports = React.createClass
  displayName: 'Game'
  componentDidMount: () ->
    @state.gameState.clockManager.initialize()
    GameState.addChangeListener @onChange
    @state.gameState.clockManager.addTickListener (clocks) =>
      h =
        jamClock: clocks.jamClock.display
        periodClock: clocks.periodClock.display
      @refs.scoreboard.refs.clocks.setState(h) if @refs.scoreboard
      @refs.jamTimer.refs.clocks.setState(h) if @refs.jamTimer
    $dom = $(@getDOMNode())
    $dom.on 'click', '.bad-status', null, (evt) ->
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      @setState
        tab: evt.currentTarget.dataset.tabName
    $dom.on 'click', '#setup', null, (evt) =>
      @setState
        tab: "game_setup"
      setTimeout () =>
        @refs.gameSetup.reloadState()
      , 1000
    $dom.on 'click', '#login', null, (evt) =>
      @setState
        tab: "login"
    GameState.addChangeListener @onChange
  componentWillUnmount: () ->
    GameState.removeChangeListener @onChange
  resetDeadmanTimer: () ->
    clearTimeout(exports.connectionTimeout)
    @gameDOM.addClass("connected")
    exports.connectionTimeout = setInterval(() =>
      @gameDOM.removeClass("connected")
    , constants.CLOCK_REFRESH_RATE_IN_MS*2)
  loadGameState: () ->
    GameState.find(@props.gameStateId)
  onChange: () ->
    @setState(gameState: @loadGameState())
  getInitialState: () ->
    gameState = @loadGameState()
    gameState: gameState
    tab: "jam_timer"
    skaterSelectorContext:
      team: gameState.away
      jam: gameState.away.jams[0]
      selectHandler: () ->
  setSelectorContext: (team, jam, selectHandler) ->
    @setState
      skaterSelectorContext:
        team: team
        jam: jam
        selectHandler: selectHandler
  defaultTab: () ->
    @setState tab: 'jam_timer'
  render: () ->
    tab = switch @state.tab
      when "jam_timer"
        <JamTimer {...@state} ref="jamTimer"/>
      when "lineup_tracker"
        <LineupTracker gameState={@state.gameState} setSelectorContext={@setSelectorContext} />
      when "scorekeeper"
        <Scorekeeper gameState={@state.gameState} setSelectorContext={@setSelectorContext} />
      when "penalty_tracker"
        <PenaltyTracker gameState={@state.gameState} />
      when "penalty_box_timer"
        <PenaltyBoxTimer gameState={@state.gameState} setSelectorContext={@setSelectorContext}/>
      when "scoreboard"
        <Scoreboard gameState={@state.gameState} ref="scoreboard"/>
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
          <Titlebar gameStateId={@state.gameState.id} />
          <div className="logo">
            <div className="container">
              <a href="#">
                <img className="hidden-xs" height="64" src="/images/logo.png" />
                <img className="visible-xs-block" height="48" src="/images/logo.png" />
              </a>
            </div>
          </div>
          <Navbar tab={@state.tab} backHandler={@props.backHandler}/>
        </div>
      </header>
      <div className="container">
        {tab}
      </div>
      <SkaterSelectorModal {...@state.skaterSelectorContext} />
    </div>
