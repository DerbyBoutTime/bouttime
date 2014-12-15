cx = React.addons.classSet
exports = exports ? this
exports.Game = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      this.setState
        tab: evt.currentTarget.dataset.tabName

  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    jamTimer = React.createElement(JamTimer, this.state)
    lineupTracker = React.createElement(LineupTracker, this.state)
    scorekeeper = React.createElement(Scorekeeper, this.state)
    penaltyTracker = React.createElement(PenaltyTracker, this.state)
    penaltyBoxTimer = React.createElement(PenaltyBoxTimer, this.state)
    scoreboard = React.createElement(Scoreboard, this.state)
    penaltyWhiteboard = React.createElement(PenaltyWhiteboard, this.state)
    announcersFeed = React.createElement(AnnouncersFeed, this.state)
    gameNotes = React.createElement(GameNotes, this.state)
    `<div className="game" data-tab={this.state.tab}>
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
        {scorekeeper}
        {penaltyTracker}
        {penaltyBoxTimer}
        {scoreboard}
        {penaltyWhiteboard}
        {announcersFeed}
        {gameNotes}
      </div>
    </div>`