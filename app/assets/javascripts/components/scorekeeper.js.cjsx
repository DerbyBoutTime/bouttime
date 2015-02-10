cx = React.addons.classSet
exports = exports ? this
exports.Scorekeeper = React.createClass
  # Helper functions
  getTeamPoints: (team)->
    points = 0
    team.jamStates.map (jam) =>
      jam.passStates.map (pass) =>
        points += pass.points
    return points

  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      state: this.state
    $.extend(std_opts, opts)

  # Display actions
  selectTeam: (teamType) ->
    this.setState(selectedTeam: teamType)

  # Data actions
  updateTeamPoints: (team) ->
    if team == "home"
      points = this.state.gameState.homeAttributes.points = this.getTeamPoints(this.state.gameState.homeAttributes)
    else
      points = this.state.gameState.awayAttributes.points = this.getTeamPoints(this.state.gameState.awayAttributes)
    this.setState(this.state)
    dispatcher.trigger "scorekeeper.set_team_points", this.getStandardOptions(team: team, points: points)

  # React callbacks
  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    componentId: exports.wftda.functions.uniqueId()
    gameState: this.props
    selectedTeam: 'away'

  render: () ->
    homeContainerClass = cx
      'col-sm-6': true
      'col-xs-12': true
      'hidden-xs': this.state.selectedTeam != 'home'

    awayContainerClass = cx
      'col-sm-6': true
      'col-xs-12': true
      'hidden-xs': this.state.selectedTeam != 'away'

    <div className="scorekeeper">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <button className="team-name btn btn-block" style={this.props.awayAttributes.colorBarStyle} onClick={this.selectTeam.bind(this, 'away')}>
            {this.state.gameState.awayAttributes.name}
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="team-name btn btn-block" style={this.props.homeAttributes.colorBarStyle} onClick={this.selectTeam.bind(this, 'home')}>
            {this.state.gameState.homeAttributes.name}
          </button>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className={awayContainerClass} id="away-team">
          <div className="row stats gutters-xs">
            <div className="col-sm-6 col-xs-6">
              <div className="stat current-jam">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Current Jam</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right current-jam-score">
                    <strong>{this.props.jamNumber}</strong>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="stat game-total">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Game Total</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right game-total-score">
                    <strong>{this.state.gameState.awayAttributes.points}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <JamsList jams={this.state.gameState.awayAttributes.jamStates} teamType="away" roster={this.state.gameState.awayAttributes.skaterStates} updateTeamPoints={this.updateTeamPoints.bind(this, "away")} />
        </div>
        <div className={homeContainerClass} id="home-team">
          <div className="row stats gutters-xs">
            <div className="col-sm-6 col-xs-6">
              <div className="stat current-jam">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Current Jam</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right current-jam-score">
                    <strong>{this.props.jamNumber}</strong>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="stat game-total">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Game Total</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right game-total-score">
                    <strong>{this.state.gameState.homeAttributes.points}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <JamsList jams={this.state.gameState.homeAttributes.jamStates} teamType="home" roster={this.state.gameState.homeAttributes.skaterStates} updateTeamPoints={this.updateTeamPoints.bind(this, "home")} />
        </div>
      </div>
    </div>
