cx = React.addons.classSet
exports = exports ? this
exports.Scorekeeper = React.createClass
  displayName: 'Scorekeeper'
  mixins: [CopyGameStateMixin]
  componentWillMount: () ->
    @actions =
      newJam: (teamType, jam) ->
        team = @getTeamState(teamType)
        team.jamStates.push(jam)
        if jam.jamNumber > @state.gameState.jamNumber
          @state.gameState.jamNumber = jam.jamNumber
        dispatcher.trigger "scorekeeper.new_jam", @getStandardOptions(teamType: teamType)
        @setState(@state)
      newPass: (teamType, jamIndex, pass) ->
        jam = @getJamState(teamType, jamIndex)
        jam.passStates.push(pass)
        dispatcher.trigger "scorekeeper.new_pass", @getStandardOptions(teamType: teamType, jamIndex: jamIndex)
        @setState(@state)
      toggleInjury: (teamType, jamIndex, passIndex) ->
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.injury = !pass.injury
        dispatcher.trigger "scorekeeper.toggle_injury", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      toggleNopass: (teamType, jamIndex, passIndex) ->
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.nopass = !pass.nopass
        dispatcher.trigger "scorekeeper.toggle_nopass", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      toggleCalloff: (teamType, jamIndex, passIndex) ->
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.calloff = !pass.calloff
        dispatcher.trigger "scorekeeper.toggle_calloff", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      toggleLostLead: (teamType, jamIndex, passIndex) ->
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.lostLead = !pass.lostLead
        dispatcher.trigger "scorekeeper.toggle_lost_lead", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      toggleLead: (teamType, jamIndex, passIndex) ->
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.lead = !pass.lead
        dispatcher.trigger "scorekeeper.toggle_lead", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      setPoints: (teamType, jamIndex, passIndex, points) ->
        jam = @getJamState(teamType, jamIndex)
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.points = points
        if passIndex is jam.passStates.length - 1
          @actions.newPass.call(this, teamType, jamIndex, {passNumber: pass.passNumber + 1, sort: pass.sort + 1 ,skaterNumber: pass.skaterNumber})
        dispatcher.trigger "scorekeeper.set_points", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      reorderPass: (teamType, jamIndex, sourcePassIndex, targetPassIndex) ->
        jam = @getJamState(teamType, jamIndex)
        list = jam.passStates
        list.splice(targetPassIndex, 0, list.splice(sourcePassIndex, 1)[0])
        pass.passNumber = i + 1 for pass, i in list
        dispatcher.trigger "scorekeeper.reorder_pass", @getStandardOptions(teamType: teamType, jamIndex: jamIndex)
        @setState(@state)
      setSkater: (teamType, jamIndex, passIndex, skaterIndex) ->
        team = @getTeamState(teamType)
        jam = @getJamState(teamType, jamIndex)
        pass = @getPassState(teamType, jamIndex, passIndex)
        skater = team.skaterStates[skaterIndex].skater
        pass.skaterNumber = skater.number
        if not jam.jammer?
          jam.jammer = skater
        dispatcher.trigger "scorekeeper.set_skater_number", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      setSelectorContext: (teamType, jamIndex, selectHandler) ->
        @props.setSelectorContext(teamType, jamIndex, selectHandler)
  # Display actions
  selectTeam: (teamType) ->
    @setState(selectedTeam: teamType)
  # Helper functions
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      state: @state.gameState
    $.extend(std_opts, opts)
  getTeamState: (teamType) ->
    switch teamType
      when 'away' then @state.gameState.awayAttributes
      when 'home' then @state.gameState.homeAttributes
  getJamState: (teamType, jamIndex) ->
    @getTeamState(teamType).jamStates[jamIndex]
  getPassState: (teamType, jamIndex, passIndex) ->
    @getJamState(teamType, jamIndex).passStates[passIndex]
  buildNewJam: (jamNumber) ->
    jamNumber: jamNumber
    passStates: []
  bindActions: (teamType) ->
    Object.keys(@actions).map((key) ->
      key: key
      value: @actions[key].bind(this, teamType)
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
      jamNumber={@state.gameState.jamNumber}
      teamState={@getTeamState('away')}
      actions={@bindActions('away')} />
    homeElement = <JamsList
      jamNumber={@state.gameState.jamNumber}
      teamState={@getTeamState('home')}
      actions={@bindActions('home')} />
    <div className="scorekeeper">
      <TeamSelector
        awayAttributes={@state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={@state.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>
