cx = React.addons.classSet
exports = exports ? this
exports.Game = React.createClass
  displayName: 'Game'

  mixins: [GameStateMixin]

  componentDidMount: () ->
    $dom = $(this.getDOMNode())
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      this.setState
        tab: evt.currentTarget.dataset.tabName
    $dom.on 'click', '#setup', null, (evt) =>
      this.setState
        tab: "game_setup"
    $dom.on 'click', '#login', null, (evt) =>
      this.setState
        tab: "login"
    exports.dispatcher.bind 'update', (state) =>
      console.log "Update received"
      this.setState(gameState: exports.wftda.functions.camelize(state))

  getInitialState: () ->
    gameState = exports.wftda.functions.camelize(this.props)
    gameState: gameState
    tab: "jam_timer"
    skaterSelectorContext:
      teamState: gameState.awayAttributes
      jamState: gameState.awayAttributes.jamStates[0]
      selectHandler: () ->

  setSelectorContext: (teamType, jamIndex, selectHandler) ->
    this.setState
      skaterSelectorContext:
        teamState: this.getTeamState(teamType)
        jamState: this.getJamState(teamType, jamIndex)
        selectHandler: selectHandler

  render: () ->
    <div ref="game" className="game" data-tab={this.state.tab}>
      <header>
        <div className="container-fluid">
          <Titlebar />
          <div className="logo">
            <div className="container">
              <a href="#">
                <img className="hidden-xs" height="64" src="/assets/logo.png" />
                <img className="visible-xs-block" height="48" src="/assets/logo.png" />
              </a>
            </div>
          </div>
          <Navbar tab={this.state.tab}/>
        </div>
      </header>
      <div className="container">
        <JamTimer {...this.state} />
        <LineupTracker {...this.state} setSelectorContext={this.setSelectorContext} />
        <Scorekeeper {...this.state} setSelectorContext={this.setSelectorContext} />
        <PenaltyTracker {...this.state} />
        <PenaltyBoxTimer {...this.state} />
        <Scoreboard {...this.state} />
        <PenaltyWhiteboard {...this.state} />
        <AnnouncersFeed {...this.state} />
        <GameNotes {...this.state} />
        <GameSetup {...this.state} />
        <Login />
      </div>
      <SkaterSelectorModal {...this.state.skaterSelectorContext} />
    </div>
