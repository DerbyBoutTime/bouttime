cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  displayName: 'LineupTracker'

  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    this.stateStack = []
    gameState: this.props
    selectorContext:
      roster: []
      buttonHandler: this.selectSkater.bind(this, 0, 'away', 'pivot')
    selectedTeam: 'away'

  buildOptions: () ->
    role: 'Lineup Tracker'
    timestamp: Date.now
    state: this.state.gameState

  pushState: () ->
    this.stateStack.push($.extend(true, {}, this.state))

  selectTeam: (team) ->
    this.state.selectedTeam = team
    this.setState(this.state)

  undo: () ->
    previousState = this.stateStack.pop()
    if previousState
      this.state = previousState
      this.setState(this.state)

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

  endJam: (team) ->
    this.pushState()
    team = this.getTeamAttributes(team)
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

  positionsInBox: (jam) ->
    positions = []
    for row in jam.lineupStatuses
      for position, status of row
        positions.push(position) if status in ['went_to_box', 'sat_in_box']
    positions


  getJamState: (jamIndex, team) ->
    switch team
      when 'away' then this.state.gameState.awayAttributes.jamStates[jamIndex]
      when 'home' then this.state.gameState.homeAttributes.jamStates[jamIndex]

  getTeamAttributes: (team) ->
    switch team
      when 'away' then this.state.gameState.awayAttributes
      when 'home' then this.state.gameState.homeAttributes

  toggleNoPivot: (jamIndex, team) ->
    this.pushState()
    teamState = this.getJamState(jamIndex, team)
    teamState.noPivot = !teamState.noPivot
    this.setState(this.state)


  toggleStarPass: (jamIndex, team) ->
    this.pushState()
    teamState = this.getJamState(jamIndex, team)
    teamState.starPass = !teamState.starPass
    this.setState(this.state)

  statusTransition: (status) ->
    switch status
      when 'clear' then 'went_to_box'
      when 'went_to_box' then 'went_to_box_and_released'
      when 'went_to_box_and_released' then 'sat_in_box'
      when 'sat_in_box' then 'sat_in_box_and_released'
      when 'sat_in_box_and_released' then 'injured'
      when 'injured' then 'clear'
      else 'clear'

  toggleBox: (jamIndex, team, statusIndex, position) ->
    this.pushState()

    teamState = this.getJamState(jamIndex, team)

    # Make a new row if need be
    if statusIndex >= teamState.lineupStatuses.length
      teamState.lineupStatuses[statusIndex] = {pivot: 'clear', blocker1: 'clear', blocker2: 'clear', blocker3: 'clear', jammer: 'clear' }

    # Initialize position to clear
    if not teamState.lineupStatuses[statusIndex][position]
      teamState.lineupStatuses[statusIndex][position] = 'clear'

    currentStatus = teamState.lineupStatuses[statusIndex][position]
    teamState.lineupStatuses[statusIndex][position] = this.statusTransition(currentStatus)
    this.setState(this.state)

  setSelectorContext: (jamIndex, team, position) ->
    this.state.selectorContext = 
      roster: this.getTeamAttributes(team).skaters
      buttonHandler: this.selectSkater.bind(this, jamIndex, team, position)
      style: this.getTeamAttributes(team).colorBarStyle
    this.setState(this.state)

  selectSkater: (jamIndex, team, position, rosterIndex) ->
    this.pushState()
    jamState = this.getJamState(jamIndex, team)
    teamAttributes = this.getTeamAttributes(team)
    jamState[position] = teamAttributes.skaters[rosterIndex]
    this.setState(this.state)

  render: () ->
    homeActiveTeamClass = cx
      'hidden-xs': this.state.selectedTeam != 'home'

    awayActiveTeamClass = cx
      'hidden-xs': this.state.selectedTeam != 'away'

    <div className="lineup-tracker">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <button className="team-name btn btn-block" style={this.props.awayAttributes.colorBarStyle} onClick={this.selectTeam.bind(this, 'away')}>
            {this.props.awayAttributes.name}
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="team-name btn btn-block" style={this.props.homeAttributes.colorBarStyle} onClick={this.selectTeam.bind(this, 'home')}>
            {this.props.homeAttributes.name}
          </button>
        </div>
      </div>
      <div className="active-team">
        <div className="row gutters-xs">
          <div className="col-sm-6 col-xs-6">
            <div className={awayActiveTeamClass}></div>
          </div>
          <div className="col-sm-6 col-xs-6">
            <div className={homeActiveTeamClass}></div>
          </div>
        </div>
      </div>
        <div className="row gutters-xs jam-details">
          <div className={awayActiveTeamClass + " col-sm-6 col-xs-12"} id="away-team">
            {this.state.gameState.awayAttributes.jamStates.map (jamState, jamIndex) ->
              <JamDetail
                key={jamIndex}
                teamAttributes={this.props.awayAttributes}
                jamState={jamState}
                noPivotHandler={this.toggleNoPivot.bind(this, jamIndex, 'away')}
                starPassHandler={this.toggleStarPass.bind(this, jamIndex, 'away')}
                boxHandler={this.toggleBox.bind(this, jamIndex, 'away')}
                setSelectorContextHandler={this.setSelectorContext.bind(this, jamIndex, 'away')}
                selectSkaterHandler={this.selectSkater.bind(this, jamIndex, 'away')} />
            , this }
            <LineupTrackerActions endHandler={this.endJam.bind(this, 'away')} undoHandler={this.undo}/>
          </div>
          <div className={homeActiveTeamClass + " col-sm-6 col-xs-12"} id="home-team">
            {this.state.gameState.homeAttributes.jamStates.map (jamState, jamIndex) ->
              <JamDetail
                key={jamIndex}
                teamAttributes={this.props.homeAttributes}
                jamState={jamState}
                noPivotHandler={this.toggleNoPivot.bind(this, jamIndex, 'home')}
                starPassHandler={this.toggleStarPass.bind(this, jamIndex, 'home')}
                boxHandler={this.toggleBox.bind(this, jamIndex, 'home')}
                setSelectorContextHandler={this.setSelectorContext.bind(this, jamIndex, 'home')}
                selectSkaterHandler={this.selectSkater.bind(this, jamIndex, 'home')} />
            , this }
            <LineupTrackerActions endHandler={this.endJam.bind(this, 'home')} undoHandler={this.undo}/>
          </div>
        </div>
      <SkaterSelectorDialog roster={this.state.selectorContext.roster} buttonHandler={this.state.selectorContext.buttonHandler} style={this.state.selectorContext.style} />
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
            END
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
    boxHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired

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

    <div>
      <div className="row gutters-xs jam-detail">
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
        <div className="col-sm-2 col-xs-2 text-center">
          <strong>J</strong>
        </div>
      </div>
      <div className="row gutters-xs skaters">
        <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2">
          <SkaterSelector skater={this.props.jamState.pivot} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "pivot")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector skater={this.props.jamState.blocker1} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker1")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector skater={this.props.jamState.blocker2} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker2")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector skater={this.props.jamState.blocker3} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker3")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector skater={this.props.jamState.jammer} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "jammer")} />
        </div>
      </div>
      {this.props.jamState.lineupStatuses.map (lineupStatus, statusIndex) ->
        <LineupBoxRow key={statusIndex} lineupStatus=lineupStatus boxHandler={this.props.boxHandler.bind(this, statusIndex)} /> 
      , this }
      <LineupBoxRow key={this.props.jamState.lineupStatuses.length} boxHandler={this.props.boxHandler.bind(this, this.props.jamState.lineupStatuses.length)} />
    </div>

exports.SkaterSelector = React.createClass
  displayName: 'SkaterSelector'
  propTypes:
    skater: React.PropTypes.object
    style: React.PropTypes.object
    buttonHandler: React.PropTypes.func.isRequired

  buttonContent: () ->
    if this.props.skater
      this.props.skater.number
    else
      <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>


  render: () ->
    <button className="skater-selector text-center btn btn-block" data-toggle="modal" style={if this.props.skater then this.props.style else {}} data-target="#roster-modal" onClick={this.props.buttonHandler}>
      <strong>{this.buttonContent()}</strong>
    </button>

exports.SkaterSelectorDialog = React.createClass
  displayName: 'SkaterSelectorDialog'
  propTypes:
    roster: React.PropTypes.array.isRequired
    buttonHandler: React.PropTypes.func
    style: React.PropTypes.object

  render: () ->
    <div className="modal fade" id="roster-modal">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal"><span>&times;</span></button>
            <h4 className="modal-title">Select Skater</h4>
          </div>
          <div className="modal-body">
            {this.props.roster.map (skater, rosterIndex) ->
                <button key={rosterIndex} className="btn btn-block" style={this.props.style} data-dismiss="modal" onClick={this.props.buttonHandler.bind(this, rosterIndex)}><strong>{skater.name} - {skater.number}</strong></button>
            , this}
          </div>
        </div>
      </div>
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
          <LineupBox status={this.props.lineupStatus.pivot} boxHandler={this.props.boxHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.blocker1} boxHandler={this.props.boxHandler.bind(this, 'blocker1')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.blocker2} boxHandler={this.props.boxHandler.bind(this, 'blocker2')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.blocker3} boxHandler={this.props.boxHandler.bind(this, 'blocker3')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.lineupStatus.jammer} boxHandler={this.props.boxHandler.bind(this, 'jammer')} />
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
    <button className="box text-center btn btn-block btn-box" onClick={this.props.boxHandler}>
      <strong>{this.boxContent()}</strong>
    </button>

