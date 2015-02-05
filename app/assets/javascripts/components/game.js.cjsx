cx = React.addons.classSet
exports = exports ? this
exports.Game = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      this.setState
        tab: evt.currentTarget.dataset.tabName
    exports.dispatcher.bind 'update', (state) =>
      console.log "Update received"
      this.setState(exports.wftda.functions.camelize(state))
  getInitialState: () ->
    $.extend exports.wftda.functions.camelize(this.props),
      tab: "jam_timer"
  render: () ->
    # console.log "Jam Time: #{this.state.jamClockAttributes.display}"
    jamTimer            = React.createElement(JamTimer, this.state)
    lineupTracker       = React.createElement(LineupTracker, this.state)
    # scorekeeper         = React.createElement(Scorekeeper, this.state)
    penaltyTracker      = React.createElement(PenaltyTracker, this.state)
    penaltyBoxTimer     = React.createElement(PenaltyBoxTimer, this.state)
    scoreboard          = React.createElement(Scoreboard, this.state)
    penaltyWhiteboard   = React.createElement(PenaltyWhiteboard, this.state)
    announcersFeed      = React.createElement(AnnouncersFeed, this.state)
    gameNotes           = React.createElement(GameNotes, this.state)
    <div className="game" data-tab={this.state.tab}>
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
        {jamTimer}
        {lineupTracker}
        {penaltyTracker}
        {penaltyBoxTimer}
        {scoreboard}
        {penaltyWhiteboard}
        {announcersFeed}
        {gameNotes}
      </div>
    </div>
