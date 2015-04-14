React = require 'react/addons'
functions = require '../functions.coffee'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
JamsList = require './scorekeeper/jams_list.cjsx'
Jam = require '../models/jam.coffee'
Pass = require '../models/pass.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'Scorekeeper'
  mixins: [CopyGameStateMixin]
  componentDidMount: () ->
    Jam.addChangeListener @onChange
    Pass.addChangeListener @onChange
  componentWillUnmount: () ->
    Jam.removeChangeListener @onChange
    Pass.addChangeListener @onChange
  getInitialState: () ->
    componentId: functions.uniqueId()
    selectedTeam: 'away'
  render: () ->
    awayElement = <JamsList
      jamNumber={@state.gameState.jamNumber}
      team={@state.gameState.away}
      setSelectorContext={@props.setSelectorContext.bind(null, @state.gameState.away)} />
    homeElement = <JamsList
      jamNumber={@state.gameState.jamNumber}
      team={@state.gameState.home}
      setSelectorContext={@props.setSelectorContext.bind(null, @state.gameState.home)} />
    <div className="scorekeeper">
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={@state.gameState.home}
        homeElement={homeElement} />
    </div>
