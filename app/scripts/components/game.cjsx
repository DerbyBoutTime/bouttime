React = require 'react/addons'
constants = require '../constants.coffee'
functions = require '../functions.coffee'
GameStateMixin = require '../mixins/game_state_mixin.cjsx'
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
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'

cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'Game'
  mixins: [CopyGameStateMixin]
  componentDidMount: () ->
    @state.gameState.clockManager.initialize()
    GameState.addChangeListener @onChange
    # @state.gameState.clockManager.addTickListener (clocks) =>
    #   @setState(clocks)
    $dom = $(@getDOMNode())
    $dom.on 'click', '.bad-status', null, (evt) ->
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      @setState
        tab: evt.currentTarget.dataset.tabName
    $dom.on 'click', '#setup', null, (evt) =>
      @setState
        tab: "game_setup"
    $dom.on 'click', '#login', null, (evt) =>
      @setState
        tab: "login"
  componentDidUnmount: () ->
    @state.gameState.clockManager.destroy()
    GameState.removeChangeListener @onChange
  getInitialState: () ->
    gameState = @props
    gameState: gameState
    tab: "jam_timer"
    skaterSelectorContext:
      team: gameState.away
      jam: gameState.away.getJams()[0]
      selectHandler: () ->
  setSelectorContext: (team, jam, selectHandler) ->
    @setState
      skaterSelectorContext:
        team: team
        jam: jam
        selectHandler: selectHandler
  render: () ->
    <div ref="game" className="game" data-tab={@state.tab}>
      <header>
        <div className="container-fluid">
          <Titlebar {...@state} />
          <div className="logo">
            <div className="container">
              <a href="#">
                <img className="hidden-xs" height="64" src="/images/logo.png" />
                <img className="visible-xs-block" height="48" src="/images/logo.png" />
              </a>
            </div>
          </div>
          <Navbar tab={@state.tab}/>
        </div>
      </header>
      <div className="container">
        <JamTimer {...@state} />
        <LineupTracker gameStateId={@props.id} setSelectorContext={@setSelectorContext} />
        <Scorekeeper gameStateId={@props.id} setSelectorContext={@setSelectorContext} />
        <PenaltyTracker gameStateId={@props.id} />
        <PenaltyBoxTimer gameStateId={@props.id} setSelectorContext={@setSelectorContext}/>
        <Scoreboard gameStateId={@props.id} />
        <PenaltyWhiteboard {...@state} />
        <AnnouncersFeed gameStateId={@props.id} />
        <GameNotes gameStateId={@props.id} />
        <GameSetup gameStateId={@props.id} />
        <Login />
      </div>
      <SkaterSelectorModal {...@state.skaterSelectorContext} />
    </div>
