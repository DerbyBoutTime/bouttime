cx = React.addons.classSet
exports = exports ? this
exports.Scorekeeper = React.createClass
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

  updateTeamPoints: (team) ->
    if team == "home"
      points = this.state.homeAttributes.points = this.getTeamPoints(this.state.homeAttributes)
    else
      points = this.state.awayAttributes.points = this.getTeamPoints(this.state.awayAttributes)
    this.setState(this.state)
    dispatcher.trigger "scorekeeper.set_team_points", this.getStandardOptions(team: team, points: points)

  # click event handlers
  handleToggleTeam: (e) ->
    this.state.homeAttributes.isSelected = !this.state.homeAttributes.isSelected
    this.state.awayAttributes.isSelected = !this.state.awayAttributes.isSelected
    this.setState(this.state)

  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    # make sure one of the tabs isSelected
    if this.props.homeAttributes.isSelected == this.props.awayAttributes.isSelected
      this.props.homeAttributes.isSelected = !this.props.homeAttributes.isSelected
    state =
      componentId: exports.wftda.functions.uniqueId()
      homeAttributes: this.props.homeAttributes
      awayAttributes: this.props.awayAttributes
      jamSelected: null

  componentWillReceiveProps: (props) ->
    this.state.homeAttributes.jamStates = props.homeAttributes.jamStates
    this.state.awayAttributes.jamStates = props.awayAttributes.jamStates
    this.setState(this.state)

  componentDidMount: () ->
    # ...

  render: () ->
    homeActiveTeamClass = cx
      'home': true
      'hidden-xs': !this.state.homeAttributes.isSelected

    homeContainerClass = cx
      'col-sm-6': true
      'col-xs-12': true
      'hidden-xs': !this.state.homeAttributes.isSelected

    awayActiveTeamClass = cx
      'away': true
      'hidden-xs': !this.state.awayAttributes.isSelected

    awayContainerClass = cx
      'col-sm-6': true
      'col-xs-12': true
      'hidden-xs': !this.state.awayAttributes.isSelected

    <div className="scorekeeper">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.awayAttributes.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.state.awayAttributes.name}
          </div>
        </div>
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.homeAttributes.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.state.homeAttributes.name}
          </div>
        </div>
      </div>
      <div className="active-team">
        <div className="row gutters-xs">
          <div className="col-sm-6 col-xs-6">
            <div className={awayActiveTeamClass}></div>
          </div>
          <div className="col-sm-6 col-xs-6">
            <div className={homeActiveTeamClass}></div>
          </div>
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
                    <strong>{this.state.awayAttributes.points}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <JamsList jams={this.state.awayAttributes.jamStates} teamType="away" roster={this.state.awayAttributes.skaterStates} updateTeamPoints={this.updateTeamPoints.bind(this, "away")} />
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
                    <strong>{this.state.homeAttributes.points}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <JamsList jams={this.state.homeAttributes.jamStates} teamType="home" roster={this.state.homeAttributes.skaterStates} updateTeamPoints={this.updateTeamPoints.bind(this, "home")} />
        </div>
      </div>
    </div>
