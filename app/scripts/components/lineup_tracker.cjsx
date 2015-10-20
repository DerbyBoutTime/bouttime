React = require 'react/addons'
TeamSelector = require './shared/team_selector'
TeamLineup = require './lineup_tracker/team_lineup'
LineupSelector = require './lineup_tracker/lineup_selector'
Jam = require '../models/jam.coffee'
cx = React.addons.classSet
Mousetrap = require 'mousetrap'
module.exports = React.createClass
  displayName: 'LineupTracker'
  componentDidMount: () ->
    that = this;
    Jam.addChangeListener @onChange
    Mousetrap.bind ['q', 'p', '#', '*'], @handleShortcut
  componentWillUnmount: () ->
    Jam.removeChangeListener @onChange
    Mousetrap.reset()
  handleShortcut: (evt, keyText) =>
    that = this
    switch keyText
      when "q" then that.refs.away.refs.jamDetail.toggleNoPivot()
      when "p" then that.refs.home.refs.jamDetail.toggleNoPivot()
      when "#" then that.refs.away.refs.jamDetail.toggleStarPass()
      when "*" then that.refs.home.refs.jamDetail.toggleStarPass()
  onChange: () ->
    Jam.find @state.lineupSelectorContext.jam?.id
    .then (jam) =>
      @setSelectorContext(
        @state.lineupSelectorContext.team,
        jam,
        @state.lineupSelectorContext.selectHandler)
  getInitialState: () ->
    lineupSelectorContext:
      team: null
      jam: null
      selectHandler: null
  setSelectorContext: (team, jam, selectHandler) ->
    @setState
      lineupSelectorContext:
        team: team
        jam: jam
        selectHandler: selectHandler
  #React callbacks
  render: () ->
    awayElement = <TeamLineup
      team={@props.gameState.away}
      ref="away"
      setSelectorContextHandler={@setSelectorContext.bind(null, @props.gameState.away)} />
    homeElement = <TeamLineup
      team={@props.gameState.home}
      ref="home"
      setSelectorContextHandler={@setSelectorContext.bind(null, @props.gameState.home)} />
    <div className="lineup-tracker">
      <TeamSelector
        away={@props.gameState.away}
        awayElement={awayElement}
        home={@props.gameState.home}
        homeElement={homeElement} />
      <LineupSelector ref="lineupSelector" {...@state.lineupSelectorContext} />
    </div>

