React = require 'react/addons'
CopyGameStateMixin = require '../mixins/copy_game_state_mixin.cjsx'
TeamSelector = require './shared/team_selector.cjsx'
TeamLineup = require './lineup_tracker/team_lineup.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupTracker'
  mixins: [CopyGameStateMixin]
  #React callbacks
  getInitialState: () ->
  #Helper functions
  buildOptions: (opts = {}) ->
    stdOpts =
      role: 'Lineup Tracker'
      timestamp: Date.now
      state: @state.gameState
      options: opts
    $.extend(stdOpts, opts)
  getJamState: (team, jamIndex) ->
    switch team
      when 'away' then @state.gameState.away.jams[jamIndex]
      when 'home' then @state.gameState.home.jams[jamIndex]
  getTeamAttributes: (team) ->
    switch team
      when 'away' then @state.gameState.away
      when 'home' then @state.gameState.home
  positionsInBox: (jam) ->
    positions = []
    for row in jam.lineupStatuses
      for position, status of row
        positions.push(position) if status in ['went_to_box', 'sat_in_box']
    positions
  getNewJam: (jamNumber) ->
    jamNumber: jamNumber
    noPivot: false
    starPass: false
    pivot: null
    blocker1: null
    blocker2: null
    blocker3: null
    jammer: null
    lineupStatuses: []
  statusTransition: (status) ->
    switch status
      when 'clear' then 'went_to_box'
      when 'went_to_box' then 'went_to_box_and_released'
      when 'went_to_box_and_released' then 'sat_in_box'
      when 'sat_in_box' then 'sat_in_box_and_released'
      when 'sat_in_box_and_released' then 'injured'
      when 'injured' then 'clear'
      else 'clear'
  #Display actions
  selectTeam: (team) ->
    @state.selectedTeam = team
    @setState(@state)
  #Data actions
  toggleNoPivot: (teamType, jamIndex) ->
    eventName = "lineup_tracker.toggle_no_pivot"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
    )
    team = @getJamState(teamType, jamIndex)
    team.noPivot = !team.noPivot
    @setState(@state)
  toggleStarPass: (teamType, jamIndex) ->
    eventName = "lineup_tracker.toggle_star_pass"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
    )
    team = @getJamState(teamType, jamIndex)
    team.starPass = !team.starPass
    @setState(@state)
  setSkater: (teamType, jamIndex, position, skaterIndex) ->
    eventName = "lineup_tracker.set_skater"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
      position: position
    )
    jam = @getJamState(teamType, jamIndex)
    teamAttributes = @getTeamAttributes(teamType)
    jam[position] = teamAttributes.skaters[skaterIndex]
    @setState(@state)
  setLineupStatus: (teamType, jamIndex, statusIndex, position) ->
    eventName = "lineup_tracker.set_lineup_status"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
      statusIndex: statusIndex
      position: position
    )
    team = @getJamState(teamType, jamIndex)
    # Make a new row if need be
    if statusIndex >= team.lineupStatuses.length
      team.lineupStatuses[statusIndex] = {pivot: 'clear', blocker1: 'clear', blocker2: 'clear', blocker3: 'clear', jammer: 'clear', order: statusIndex }
    # Initialize position to clear
    if not team.lineupStatuses[statusIndex][position]
      team.lineupStatuses[statusIndex][position] = 'clear'
    currentStatus = team.lineupStatuses[statusIndex][position]
    team.lineupStatuses[statusIndex][position] = @statusTransition(currentStatus)
    @setState(@state)
  endJam: (teamType) ->
    eventName = "lineup_tracker.end_jam"
    eventOptions = @buildOptions(
      teamType: teamType
    )
    team = @getTeamAttributes(teamType)
    lastJam = team.jams[team.jams.length - 1]
    newJam = @getNewJam(lastJam.jamNumber + 1)
    positionsInBox = @positionsInBox(lastJam)
    if positionsInBox.length > 0
      newJam.lineupStatuses[0] = {}
      for position in positionsInBox
        newJam[position] = lastJam[position]
        newJam.lineupStatuses[0][position] = 'sat_in_box'
    team.jams.push(newJam)
    @setState(@state)
  render: () ->
    awayElement = <TeamLineup
      team={@props.gameState.away}
      noPivotHandler={@toggleNoPivot.bind(this, 'away')}
      starPassHandler={@toggleStarPass.bind(this, 'away')}
      lineupStatusHandler={@setLineupStatus.bind(this, 'away')}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, 'away')}
      selectSkaterHandler={@setSkater.bind(this,'away')}
      endHandler={@endJam.bind(this, 'away')} />
    homeElement = <TeamLineup
      team={@props.gameState.home}
      noPivotHandler={@toggleNoPivot.bind(this, 'home')}
      starPassHandler={@toggleStarPass.bind(this, 'home')}
      lineupStatusHandler={@setLineupStatus.bind(this, 'home')}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, 'home')}
      selectSkaterHandler={@setSkater.bind(this, 'home')}
      endHandler={@endJam.bind(this, 'home')} />
    <div className="lineup-tracker">
      <TeamSelector
        away={@state.gameState.away}
        awayElement={awayElement}
        home={@state.gameState.home}
        homeElement={homeElement} />
    </div>
