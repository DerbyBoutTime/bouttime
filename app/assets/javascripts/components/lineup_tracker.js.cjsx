cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  displayName: 'LineupTracker'
  mixins: [CopyGameStateMixin]
  #React callbacks
  getInitialState: () ->
    @stateStack = []
  #Helper functions
  buildOptions: (opts = {}) ->
    stdOpts =
      role: 'Lineup Tracker'
      timestamp: Date.now
      state: @state.gameState
      options: opts
    $.extend(stdOpts, opts)
  pushState: (eventName, eventOptions) ->
    @stateStack.push
      gameState: $.extend(true, {}, @state.gameState)
      eventName: eventName
      eventOptions: $.extend(true, {}, eventOptions)
  getJamState: (team, jamIndex) ->
    switch team
      when 'away' then @state.gameState.awayAttributes.jamStates[jamIndex]
      when 'home' then @state.gameState.homeAttributes.jamStates[jamIndex]
  getTeamAttributes: (team) ->
    switch team
      when 'away' then @state.gameState.awayAttributes
      when 'home' then @state.gameState.homeAttributes
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
    @pushState(eventName, eventOptions)
    teamState = @getJamState(teamType, jamIndex)
    teamState.noPivot = !teamState.noPivot
    @setState(@state)
    exports.dispatcher.trigger eventName, eventOptions
  toggleStarPass: (teamType, jamIndex) ->
    eventName = "lineup_tracker.toggle_star_pass"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
    )
    @pushState(eventName, eventOptions)
    teamState = @getJamState(teamType, jamIndex)
    teamState.starPass = !teamState.starPass
    @setState(@state)
    exports.dispatcher.trigger eventName, eventOptions
  setSkater: (teamType, jamIndex, position, skaterIndex) ->
    eventName = "lineup_tracker.set_skater"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
      position: position
    )
    @pushState(eventName, eventOptions)
    jamState = @getJamState(teamType, jamIndex)
    teamAttributes = @getTeamAttributes(teamType)
    jamState[position] = teamAttributes.skaters[skaterIndex]
    @setState(@state)
    exports.dispatcher.trigger eventName, eventOptions
  setLineupStatus: (teamType, jamIndex, statusIndex, position) ->
    eventName = "lineup_tracker.set_lineup_status"
    eventOptions = @buildOptions(
      jamIndex: jamIndex
      teamType: teamType
      statusIndex: statusIndex
      position: position
    )
    @pushState(eventName, eventOptions)
    teamState = @getJamState(teamType, jamIndex)
    # Make a new row if need be
    if statusIndex >= teamState.lineupStatuses.length
      teamState.lineupStatuses[statusIndex] = {pivot: 'clear', blocker1: 'clear', blocker2: 'clear', blocker3: 'clear', jammer: 'clear', order: statusIndex }
    # Initialize position to clear
    if not teamState.lineupStatuses[statusIndex][position]
      teamState.lineupStatuses[statusIndex][position] = 'clear'
    currentStatus = teamState.lineupStatuses[statusIndex][position]
    teamState.lineupStatuses[statusIndex][position] = @statusTransition(currentStatus)
    @setState(@state)
    exports.dispatcher.trigger eventName, eventOptions
  endJam: (teamType) ->
    eventName = "lineup_tracker.end_jam"
    eventOptions = @buildOptions(
      teamType: teamType
    )
    @pushState(eventName, eventOptions)
    team = @getTeamAttributes(teamType)
    lastJam = team.jamStates[team.jamStates.length - 1]
    newJam = @getNewJam(lastJam.jamNumber + 1)
    positionsInBox = @positionsInBox(lastJam)
    if positionsInBox.length > 0
      newJam.lineupStatuses[0] = {}
      for position in positionsInBox
        newJam[position] = lastJam[position]
        newJam.lineupStatuses[0][position] = 'sat_in_box'
    team.jamStates.push(newJam)
    @setState(@state)
    exports.dispatcher.trigger eventName, eventOptions
  undo: () ->
    frame = @stateStack.pop()
    if frame
      previousGameState = frame.gameState
      previousEventName = frame.eventName
      previousEventOptions = frame.eventOptions
      @setState(gameState: previousGameState)
      exports.dispatcher.trigger previousEventName, previousEventOptions
  render: () ->
    awayElement = <TeamLineup
      teamState={@props.gameState.awayAttributes}
      noPivotHandler={@toggleNoPivot.bind(this, 'away')}
      starPassHandler={@toggleStarPass.bind(this, 'away')}
      lineupStatusHandler={@setLineupStatus.bind(this, 'away')}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, 'away')}
      selectSkaterHandler={@setSkater.bind(this,'away')}
      endHandler={@endJam.bind(this, 'away')}
      undoHandler={@undo} />
    homeElement = <TeamLineup
      teamState={@props.gameState.homeAttributes}
      noPivotHandler={@toggleNoPivot.bind(this, 'home')}
      starPassHandler={@toggleStarPass.bind(this, 'home')}
      lineupStatusHandler={@setLineupStatus.bind(this, 'home')}
      setSelectorContextHandler={@props.setSelectorContext.bind(null, 'home')}
      selectSkaterHandler={@setSkater.bind(this, 'home')}
      endHandler={@endJam.bind(this, 'home')}
      undoHandler={@undo} />
    <div className="lineup-tracker">
      <TeamSelector
        awayAttributes={@state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={@state.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>
