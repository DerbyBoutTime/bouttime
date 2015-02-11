cx = React.addons.classSet
exports = exports ? this
exports.Scorekeeper = React.createClass
  displayName: 'Scorekeeper'

  componentWillMount: () ->
    this.actions = 
      newJam: (teamType, jam) ->
        team = this.getTeamState(teamType)
        team.jamStates.push(jam)
        this.setState(this.state)

      newPass: (teamType, jamIndex, pass) ->
        jam = this.getJamState(teamType, jamIndex)
        jam.passStates.push(pass)
        this.setState(this.state)

      toggleInjury: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.injury = !pass.injury
        dispatcher.trigger "scorekeeper.toggle_injury", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleNopass: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.nopass = !pass.nopass
        dispatcher.trigger "scorekeeper.toggle_nopass", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleCalloff: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.calloff = !pass.calloff
        dispatcher.trigger "scorekeeper.toggle_calloff", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleLostLead: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.lostLead = !pass.lostLead
        dispatcher.trigger "scorekeeper.toggle_lost_lead", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      toggleLead: (teamType, jamIndex, passIndex) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.lead = !pass.lead
        dispatcher.trigger "scorekeeper.toggle_lead", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      setPoints: (teamType, jamIndex, passIndex, points) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.points = points
        dispatcher.trigger "scorekeeper.set_points", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      setPassNumber: (teamType, jamIndex, passIndex, passNumber) ->
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.passNumber = passNumber
        dispatcher.trigger "scorekeeper.set_pass_number", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passInex: passIndex)
        this.setState(this.state)

  # Display actions
  selectTeam: (teamType) ->
    this.setState(selectedTeam: teamType)

  # Helper functions
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      state: this.state
    $.extend(std_opts, opts)

  getTeamState: (teamType) ->
    switch teamType
      when 'away' then this.state.gameState.awayAttributes
      when 'home' then this.state.gameState.homeAttributes

  getJamState: (teamType, jamIndex) ->
    this.getTeamState(teamType).jamStates[jamIndex]

  getPassState: (teamType, jamIndex, passIndex) ->
    jam = this.getJamState(teamType, jamIndex)
    if jam.passStates.length == passIndex
      lastPass = jam.passStates[jam.passStates.length - 1]
      jam.passStates.push(passNumber: if lastPass? then lastPass.passNumber + 1 else 1)
    jam.passStates[passIndex]

  getTeamPoints: (teamType)->
    team = this.getTeamState(teamType)
    points = 0
    team.jamStates.map (jam) =>
      jam.passStates.map (pass) =>
        points += pass.points || 0
    return points

  buildNewJam: (jamNumber) ->
    jamNumber: jamNumber
    passStates: []

  bindActions: (teamType) ->
    Object.keys(this.actions).map((key) ->
      key: key
      value: this.actions[key].bind(this, teamType)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})

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
                    <strong>{this.getTeamPoints('away')}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <JamsList 
            teamState={this.getTeamState('away')}
            actions={this.bindActions('away')} />
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
                    <strong>{this.getTeamPoints('home')}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <JamsList 
            teamState={this.getTeamState('home')}
            actions={this.bindActions('home')} />
        </div>
      </div>
    </div>
