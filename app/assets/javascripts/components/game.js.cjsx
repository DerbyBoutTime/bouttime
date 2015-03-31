cx = React.addons.classSet
exports = exports ? this
exports.Game = React.createClass
  displayName: 'Game'
  mixins: [GameStateMixin]
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    @gameDOM = $(".game")
    $dom.on 'click', '.bad-status', null, (evt) ->
      exports.dispatcher.disconnect()
      exports.dispatcher.connect()
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      @setState
        tab: evt.currentTarget.dataset.tabName
    $dom.on 'click', '#setup', null, (evt) =>
      @setState
        tab: "game_setup"
    $dom.on 'click', '#login', null, (evt) =>
      @setState
        tab: "login"
    exports.dispatcher.bind 'time_update', (new_state) =>
      console.log "Time update received"
      @resetDeadmanTimer()
      @state.gameState.jamClockAttributes = new_state.jam_clock_attributes
      @state.gameState.periodClockAttributes = new_state.period_clock_attributes
      @forceUpdate()
    exports.dispatcher.bind 'update', (state) =>
      console.log "Update received"
      @setState(gameState: exports.wftda.functions.camelize(state))
  resetDeadmanTimer: () ->
    clearTimeout(exports.connectionTimeout)
    @gameDOM.addClass("connected")
    exports.connectionTimeout = setInterval(() =>
      @gameDOM.removeClass("connected")
    , exports.wftda.constants.CLOCK_REFRESH_RATE_IN_MS)
  getInitialState: () ->
    gameState = exports.wftda.functions.camelize(@props)
    gameState: gameState
    tab: "jam_timer"
    skaterSelectorContext:
      teamState: gameState.awayAttributes
      jamState: gameState.awayAttributes.jamStates[0]
      selectHandler: () ->
  setSelectorContext: (teamType, jamIndex, selectHandler) ->
    @setState
      skaterSelectorContext:
        teamState: @getTeamState(teamType)
        jamState: @getJamState(teamType, jamIndex)
        selectHandler: selectHandler
  render: () ->
    <div ref="game" className="game" data-tab={@state.tab}>
      <header>
        <div className="container-fluid">
          <Titlebar {...this.state} />
          <div className="logo">
            <div className="container">
              <a href="#">
                <img className="hidden-xs" height="64" src="/assets/logo.png" />
                <img className="visible-xs-block" height="48" src="/assets/logo.png" />
              </a>
            </div>
          </div>
          <Navbar tab={@state.tab}/>
        </div>
      </header>
      <div className="container">
        <JamTimer {...@state} />
        <LineupTracker {...@state} setSelectorContext={@setSelectorContext} />
        <Scorekeeper {...@state} setSelectorContext={@setSelectorContext} />
        <PenaltyTracker {...@state} />
        <PenaltyBoxTimer {...@state} setSelectorContext={@setSelectorContext}/>
        <Scoreboard {...@state} />
        <PenaltyWhiteboard {...@state} />
        <AnnouncersFeed {...@state} />
        <GameNotes {...@state} />
        <GameSetup {...@state} />
        <Login />
      </div>
      <SkaterSelectorModal {...@state.skaterSelectorContext} />
    </div>
