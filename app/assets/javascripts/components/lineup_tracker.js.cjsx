cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  displayName: 'LineupTracker'

  #React callbacks
  getInitialState: () ->
    this.stateStack = []
    gameState: this.props.gameState

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
    eventName="lineup_tracker.end_jam"
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

        
exports.TeamLineup = React.createClass
  displayName: 'TeamLineup'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    lineupStatusHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired
    endHandler: React.PropTypes.func.isRequired
    undoHandler: React.PropTypes.func.isRequired

  render: ()->
    <div className="jam-details">
      {this.props.teamState.jamStates.map (jamState, jamIndex) ->
        <JamDetail
          key={jamIndex}
          teamAttributes={this.props.teamState}
          jamState={jamState}
          noPivotHandler={this.props.noPivotHandler.bind(this, jamIndex)}
          starPassHandler={this.props.starPassHandler.bind(this, jamIndex)}
          lineupStatusHandler={this.props.lineupStatusHandler.bind(this, jamIndex)}
          setSelectorContextHandler={this.props.setSelectorContextHandler.bind(this, jamIndex)}
          selectSkaterHandler={this.props.selectSkaterHandler.bind(this, jamIndex)} />
      , this }
      <LineupTrackerActions endHandler={this.props.endHandler} undoHandler={this.props.undoHandler}/>
    </div>

exports.LineupTrackerActions = React.createClass
  displayName: 'LineupTrackerActions'
  propTypes:
    endHandler: React.PropTypes.func.isRequired
    undoHandler: React.PropTypes.func.isRequired

  render: () ->
    <div className="row gutters-xs actions">
        <div className="col-sm-6 col-xs-6">
          <button className="actions-action actions-edit text-center btn btn-block" onClick={this.props.endHandler}>
            NEXT JAM
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="actions-action actions-undo text-center btn btn-block" onClick={this.props.undoHandler}>
            <strong>UNDO</strong>
          </button>
        </div>
      </div>

exports.JamDetail = React.createClass
  displayName: 'JamDetail'
  propTypes:
    teamAttributes: React.PropTypes.object.isRequired
    jamState: React.PropTypes.object.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    lineupStatusHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired

  isInjured: (position) ->
    this.props.jamState.lineupStatuses.some (status) ->
      status[position] is 'injured'

  render: () ->
    noPivotButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-no-pivot': true
      'toggle-pivot-btn': true
      'selected': this.props.jamState.noPivot

    starPassButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-star-pass': true
      'toggle-star-pass-btn': true
      'selected': this.props.jamState.starPass

    actionsClass = cx
      'row': true
      'gutters-xs': true
      'actions': true

    <div className="jam-detail">
      <div className="row gutters-xs">
        <div className="col-sm-8 col-xs-8">
          <div className="jam-detail-number boxed-good">
            <div className="row gutters-xs">
              <div className="col-sm-11 col-xs-11 col-sm-offset-1 col-xs-offset-1">
                Jam {this.props.jamState.jamNumber}
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <button className={noPivotButtonClass} onClick={this.props.noPivotHandler}>
            <strong>No Pivot</strong>
          </button>
        </div>
        <div className="col-sm-2 col-xs-2">
          <button className={starPassButtonClass} onClick={this.props.starPassHandler}>
            <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
          </button>
        </div>
      </div>
      <div className="row gutters-xs positions">
        <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
          <strong>J</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>Pivot</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>B1</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>B2</strong>
        </div>
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>B3</strong>
        </div>
      </div>
      <div className="row gutters-xs skaters">
        <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2">
          <SkaterSelector
            skater={this.props.jamState.jammer}
            injured={this.isInjured('jammer')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'jammer')} />        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.pivot}
            injured={this.isInjured('pivot')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.blocker1}
            injured={this.isInjured('blocker1')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'blocker1')} />        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.blocker2}
            injured={this.isInjured('blocker2')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'blocker2')} />        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={this.props.jamState.blocker3}
            injured={this.isInjured('blocker3')}
            style={this.props.teamAttributes.colorBarStyle}
            setSelectorContext={this.props.setSelectorContextHandler}
            selectHandler={this.props.selectSkaterHandler.bind(this, 'blocker3')} />        </div>
      </div>
      {this.props.jamState.lineupStatuses.map (lineupStatus, statusIndex) ->
        <LineupBoxRow key={statusIndex} lineupStatus=lineupStatus lineupStatusHandler={this.props.lineupStatusHandler.bind(this, statusIndex)} />
      , this }
      <LineupBoxRow key={this.props.jamState.lineupStatuses.length} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, this.props.jamState.lineupStatuses.length)} />
    </div>

exports.LineupBoxRow = React.createClass
  displayName: 'LineupBoxRow'

  propTypes:
    lineupStatus: React.PropTypes.object

  getDefaultProps: () ->
    lineupStatus:
      pivot: 'clear'
      blocker1: 'clear'
      blocker2: 'clear'
      blocker3: 'clear'
      jammer: 'clear'

  render: () ->
    <div className="row gutters-xs boxes">
        <div className="col-sm-2 col-xs-2 col-sm-offest-2 col-xs-offset-2">
          <LineupBox status={this.props.lineupStatus.jammer} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'jammer')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.pivot} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.blocker1} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'blocker1')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.blocker2} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'blocker2')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.blocker3} lineupStatusHandler={this.props.lineupStatusHandler.bind(this, 'blocker3')} />
        </div>
      </div>


exports.LineupBox = React.createClass
  displayName: 'LineupBox'

  propTypes:
    status: React.PropTypes.string

  getDefaultProps: () ->
    status: 'clear'

  boxContent: () ->
    switch this.props.status
      when 'clear' then <span>&nbsp;</span>
      when null then <span>&nbsp;</span>
      when 'went_to_box' then '/'
      when 'went_to_box_and_released' then 'X'
      when 'injured' then <span className="glyphicon glyphicon-paperclip"></span>
      when 'sat_in_box' then  'S'
      when 'sat_in_box_and_released' then '$'

  render: () ->
    injuryClass = cx
      'box-injury': this.props.status is 'injured'

    <button className={injuryClass + " box text-center btn btn-block btn-box"} onClick={this.props.lineupStatusHandler}>
      <strong>{this.boxContent()}</strong>
    </button>

