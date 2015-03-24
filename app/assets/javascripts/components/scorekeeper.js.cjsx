cx = React.addons.classSet
exports = exports ? this
exports.Scorekeeper = React.createClass
  displayName: 'Scorekeeper'

  mixins: [CopyGameStateMixin]

  componentWillMount: () ->
    this.actions = 
      newJam: (teamType, jam) ->
        team = this.getTeamState(teamType)
        team.jamStates.push(jam)

        if jam.jamNumber > this.state.gameState.jamNumber
          this.state.gameState.jamNumber = jam.jamNumber
        dispatcher.trigger "scorekeeper.new_jam", this.getStandardOptions(teamType: teamType)
        this.setState(this.state)

      newPass: (teamType, jamIndex, pass) ->
        jam = this.getJamState(teamType, jamIndex)
        jam.passStates.push(pass)
        dispatcher.trigger "scorekeeper.new_pass", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex)
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
        jam = this.getJamState(teamType, jamIndex)
        pass = this.getPassState(teamType, jamIndex, passIndex)
        pass.points = points
        if passIndex is jam.passStates.length - 1
          this.actions.newPass.call(this, teamType, jamIndex, {passNumber: pass.passNumber + 1, sort: pass.sort + 1 ,skaterNumber: pass.skaterNumber})
        dispatcher.trigger "scorekeeper.set_points", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      reorderPass: (teamType, jamIndex, sourcePassIndex, targetPassIndex) ->
        jam = this.getJamState(teamType, jamIndex)
        list = jam.passStates
        list.splice(targetPassIndex, 0, list.splice(sourcePassIndex, 1)[0])
        pass.passNumber = i + 1 for pass, i in list
        dispatcher.trigger "scorekeeper.reorder_pass", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex)
        this.setState(this.state)

      setSkater: (teamType, jamIndex, passIndex, skaterIndex) ->
        team = this.getTeamState(teamType)
        pass = this.getPassState(teamType, jamIndex, passIndex)
        skater = team.skaterStates[skaterIndex].skater
        pass.skaterNumber = skater.number
        dispatcher.trigger "scorekeeper.set_skater_number", this.getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        this.setState(this.state)

      setSelectorContext: (teamType, jamIndex, selectHandler) ->
        this.props.setSelectorContext(teamType, jamIndex, selectHandler)

  # Display actions
  selectTeam: (teamType) ->
    this.setState(selectedTeam: teamType)

  # Helper functions
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      state: this.state.gameState
    $.extend(std_opts, opts)

  getTeamState: (teamType) ->
    switch teamType
      when 'away' then this.state.gameState.awayAttributes
      when 'home' then this.state.gameState.homeAttributes

  getJamState: (teamType, jamIndex) ->
    this.getTeamState(teamType).jamStates[jamIndex]

  getPassState: (teamType, jamIndex, passIndex) ->
    this.getJamState(teamType, jamIndex).passStates[passIndex]

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
    componentId: exports.wftda.functions.uniqueId()
    selectedTeam: 'away'

  render: () ->
    awayElement = <JamsList 
      jamNumber={this.state.gameState.jamNumber}
      teamState={this.getTeamState('away')}
      actions={this.bindActions('away')} />
    homeElement = <JamsList 
      jamNumber={this.state.gameState.jamNumber}
      teamState={this.getTeamState('home')}
      actions={this.bindActions('home')} />

    <div className="scorekeeper">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>
