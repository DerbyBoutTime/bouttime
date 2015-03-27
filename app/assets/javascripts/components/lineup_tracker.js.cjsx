cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  displayName: 'LineupTracker'
  mixins: [CopyGameStateMixin]
  #React callbacks
  getInitialState: () ->
    this.stateStack = []
  #Helper functions
  buildOptions: (opts = {}) ->
    stdOpts =
      role: 'Lineup Tracker'
      timestamp: Date.now
      state: this.state.gameState
      options: opts
    $.extend(stdOpts, opts)
  pushState: (eventName, eventOptions) ->
    this.stateStack.push
      gameState: $.extend(true, {}, this.state.gameState)
      eventName: eventName
      eventOptions: $.extend(true, {}, eventOptions)
  getJamState: (team, jamIndex) ->
    switch team
      when 'away' then this.state.gameState.awayAttributes.jamStates[jamIndex]
      when 'home' then this.state.gameState.homeAttributes.jamStates[jamIndex]
  getTeamAttributes: (team) ->
    switch team
      when 'away' then this.state.gameState.awayAttributes
      when 'home' then this.state.gameState.homeAttributes
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
    this.state.selectedTeam = team
    this.setState(this.state)
  #Data actions
  toggleNoPivot: (teamType, jamIndex) ->
    eventName = "lineup_tracker.toggle_no_pivot"
    eventOptions = this.buildOptions(
      jamIndex: jamIndex
      teamType: teamType
    )
    this.pushState(eventName, eventOptions)
    teamState = this.getJamState(teamType, jamIndex)
    teamState.noPivot = !teamState.noPivot
    this.setState(this.state)
    exports.dispatcher.trigger eventName, eventOptions
  toggleStarPass: (teamType, jamIndex) ->
    eventName = "lineup_tracker.toggle_star_pass"
    eventOptions = this.buildOptions(
      jamIndex: jamIndex
      teamType: teamType
    )
    this.pushState(eventName, eventOptions)
    teamState = this.getJamState(teamType, jamIndex)
    teamState.starPass = !teamState.starPass
    this.setState(this.state)
    exports.dispatcher.trigger eventName, eventOptions
  setSkater: (teamType, jamIndex, position, skaterIndex) ->
    eventName = "lineup_tracker.set_skater"
    eventOptions = this.buildOptions(
      jamIndex: jamIndex
      teamType: teamType
      position: position
    )
    this.pushState(eventName, eventOptions)
    jamState = this.getJamState(teamType, jamIndex)
    teamAttributes = this.getTeamAttributes(teamType)
    jamState[position] = teamAttributes.skaters[skaterIndex]
    this.setState(this.state)
    exports.dispatcher.trigger eventName, eventOptions
  setLineupStatus: (teamType, jamIndex, statusIndex, position) ->
    eventName = "lineup_tracker.set_lineup_status"
    eventOptions = this.buildOptions(
      jamIndex: jamIndex
      teamType: teamType
      statusIndex: statusIndex
      position: position
    )
    this.pushState(eventName, eventOptions)
    teamState = this.getJamState(teamType, jamIndex)
    # Make a new row if need be
    if statusIndex >= teamState.lineupStatuses.length
      teamState.lineupStatuses[statusIndex] = {pivot: 'clear', blocker1: 'clear', blocker2: 'clear', blocker3: 'clear', jammer: 'clear', order: statusIndex }
    # Initialize position to clear
    if not teamState.lineupStatuses[statusIndex][position]
      teamState.lineupStatuses[statusIndex][position] = 'clear'
    currentStatus = teamState.lineupStatuses[statusIndex][position]
    teamState.lineupStatuses[statusIndex][position] = this.statusTransition(currentStatus)
    this.setState(this.state)
    exports.dispatcher.trigger eventName, eventOptions
  endJam: (teamType) ->
    eventName = "lineup_tracker.end_jam"
    eventOptions = this.buildOptions(
      teamType: teamType
    )
    this.pushState(eventName, eventOptions)
    team = this.getTeamAttributes(teamType)
    lastJam = team.jamStates[team.jamStates.length - 1]
    newJam = this.getNewJam(lastJam.jamNumber + 1)
    positionsInBox = this.positionsInBox(lastJam)
    if positionsInBox.length > 0
      newJam.lineupStatuses[0] = {}
      for position in positionsInBox
        newJam[position] = lastJam[position]
        newJam.lineupStatuses[0][position] = 'sat_in_box'
    team.jamStates.push(newJam)
    this.setState(this.state)
    exports.dispatcher.trigger eventName, eventOptions
  undo: () ->
    frame = this.stateStack.pop()
    if frame
      previousGameState = frame.gameState
      previousEventName = frame.eventName
      previousEventOptions = frame.eventOptions
      this.setState(gameState: previousGameState)
      exports.dispatcher.trigger previousEventName, previousEventOptions
  render: () ->
    awayElement = <TeamLineup
      teamState={this.props.gameState.awayAttributes}
      noPivotHandler={this.toggleNoPivot.bind(this, 'away')}
      starPassHandler={this.toggleStarPass.bind(this, 'away')}
      lineupStatusHandler={this.setLineupStatus.bind(this, 'away')}
      setSelectorContextHandler={this.props.setSelectorContext.bind(null, 'away')}
      selectSkaterHandler={this.setSkater.bind(this,'away')}
      endHandler={this.endJam.bind(this, 'away')}
      undoHandler={this.undo} />
    homeElement = <TeamLineup
      teamState={this.props.gameState.homeAttributes}
      noPivotHandler={this.toggleNoPivot.bind(this, 'home')}
      starPassHandler={this.toggleStarPass.bind(this, 'home')}
      lineupStatusHandler={this.setLineupStatus.bind(this, 'home')}
      setSelectorContextHandler={this.props.setSelectorContext.bind(null, 'home')}
      selectSkaterHandler={this.setSkater.bind(this, 'home')}
      endHandler={this.endJam.bind(this, 'home')}
      undoHandler={this.undo} />
    <div className="lineup-tracker">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>