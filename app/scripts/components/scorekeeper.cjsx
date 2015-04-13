React = require 'react/addons'
functions = require '../functions.coffee'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
JamsList = require './scorekeeper/jams_list.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'Scorekeeper'
  mixins: [CopyGameStateMixin]
  componentWillMount: () ->
    @actions =
      newJam: (teamType, jam) ->
        team = @getTeam(teamType)
        team.jams.push(jam)
        if jam.jamNumber > @state.gameState.jamNumber
          @state.gameState.jamNumber = jam.jamNumber
        dispatcher.trigger "scorekeeper.new_jam", @getStandardOptions(teamType: teamType)
        @setState(@state)
      newPass: (teamType, jamIndex, pass) ->
        jam = @getJam(teamType, jamIndex)
        jam.passes.push(pass)
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
        jam = @getJam(teamType, jamIndex)
        pass = @getPassState(teamType, jamIndex, passIndex)
        pass.points = points
        if passIndex is jam.passes.length - 1
          @actions.newPass.call(this, teamType, jamIndex, {passNumber: pass.passNumber + 1, sort: pass.sort + 1 ,skaterNumber: pass.skaterNumber})
        dispatcher.trigger "scorekeeper.set_points", @getStandardOptions(teamType: teamType, jamIndex: jamIndex, passIndex: passIndex)
        @setState(@state)
      reorderPass: (teamType, jamIndex, sourcePassIndex, targetPassIndex) ->
        jam = @getJam(teamType, jamIndex)
        list = jam.passes
        list.splice(targetPassIndex, 0, list.splice(sourcePassIndex, 1)[0])
        pass.passNumber = i + 1 for pass, i in list
        dispatcher.trigger "scorekeeper.reorder_pass", @getStandardOptions(teamType: teamType, jamIndex: jamIndex)
        @setState(@state)
      setSkater: (teamType, jamIndex, passIndex, skaterIndex) ->
        team = @getTeam(teamType)
        jam = @getJam(teamType, jamIndex)
        pass = @getPassState(teamType, jamIndex, passIndex)
        skater = team.skaters[skaterIndex].skater
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
  getTeam: (teamType) ->
    switch teamType
      when 'away' then @state.gameState.away
      when 'home' then @state.gameState.home
  getJam: (teamType, jamIndex) ->
    @getTeam(teamType).jams[jamIndex]
  getPassState: (teamType, jamIndex, passIndex) ->
    @getJam(teamType, jamIndex).passes[passIndex]
  buildNewJam: (jamNumber) ->
    jamNumber: jamNumber
    passes: []
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
    componentId: functions.uniqueId()
    selectedTeam: 'away'
  render: () ->
    awayElement = <JamsList
      jamNumber={@state.gameState.jamNumber}
      team={@getTeam('away')}
      actions={@bindActions('away')} />
    homeElement = <JamsList
      jamNumber={@state.gameState.jamNumber}
      team={@getTeam('home')}
      actions={@bindActions('home')} />
    <div className="scorekeeper">
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={@state.gameState.home}
        homeElement={homeElement} />
    </div>
