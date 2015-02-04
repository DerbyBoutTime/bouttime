cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    this.stateStack = []
    lineupStatesAttributes: this.props.lineupStatesAttributes
    selectorContext:
      roster: []
      buttonHandler: this.selectSkater.bind(this, 0, 'away', 'pivot')

  buildOptions: () ->
    role: 'Lineup Tracker'
    timestamp: Date.now
    state:
      id: this.props.id
      gameState:
        lineupStatesAttributes: this.state.lineupStatesAttributes

  syncState: () ->
    exports.dispatcher.trigger "lineup_tracker.update", this.buildOptions()

  pushState: () ->
    this.stateStack.push($.extend(true, {}, this.state))

  undo: () ->
    previousState = this.stateStack.pop()
    if previousState
      this.state = previousState
      this.setState(this.state)
      this.syncState()

  getNewJam: (jamNumber) ->
    jamNumber: jamNumber
    homeStateAttributes:
      noPivot: false
      starPass: false
      pivotNumber: null
      blocker1Number: null
      blocker2Number: null
      blocker3Number: null
      jammerNumber: null
      lineupStatusStatesAttributes: []
    awayStateAttributes:
      noPivot: false
      starPass: false
      pivotNumber: null
      blocker1Number: null
      blocker2Number: null
      blocker3Number: null
      jammerNumber: null
      lineupStatusStatesAttributes: []

  endJam: () ->
    this.pushState()
    lastJam = this.state.lineupStatesAttributes[this.state.lineupStatesAttributes.length - 1]
    newJam = this.getNewJam(lastJam.jamNumber + 1)
    positionsInBox = this.positionsInBox(lastJam)
    for team in ['awayStateAttributes', 'homeStateAttributes']
      if positionsInBox[team].length > 0
        newJam[team].lineupStatusStatesAttributes[0] = {}
        for position in positionsInBox[team]
          newJam[team][position+'Number'] = lastJam[team][position+'Number']
          newJam[team].lineupStatusStatesAttributes[0][position] = 'sat_in_box'
    this.state.lineupStatesAttributes.push(newJam)
    this.setState(this.state)
    this.syncState()

  positionsInBox: (jam) ->
    positions =
      homeStateAttributes: []
      awayStateAttributes:[]
    for team in ['awayStateAttributes', 'homeStateAttributes']
      detail = jam[team]
      for row in detail.lineupStatusStatesAttributes
        for position, status of row
          positions[team].push(position) if status in ['went_to_box', 'sat_in_box']
    positions


  getTeamStateAttributes: (jamIndex, team) ->
    switch team
      when 'away' then this.state.lineupStatesAttributes[jamIndex].awayStateAttributes
      when 'home' then this.state.lineupStatesAttributes[jamIndex].homeStateAttributes

  getTeamAttributes: (team) ->
    switch team
      when 'away' then this.props.awayAttributes
      when 'home' then this.props.homeAttributes

  toggleNoPivot: (jamIndex, team) ->
    this.pushState()
    teamState = this.getTeamStateAttributes(jamIndex, team)
    teamState.noPivot = !teamState.noPivot
    this.setState(this.state)
    this.syncState()


  toggleStarPass: (jamIndex, team) ->
    this.pushState()
    teamState = this.getTeamStateAttributes(jamIndex, team)
    teamState.starPass = !teamState.starPass
    this.setState(this.state)
    this.syncState()

  toggleBox: (jamIndex, team, statusIndex, position) ->
    this.pushState()
    transition = 
      'clear': 'went_to_box'
      'went_to_box': 'went_to_box_and_released'
      'went_to_box_and_released': 'injured'
      'injured': 'clear'
      'sat_in_box': 'sat_in_box_and_released'
      'sat_in_box_and_released': 'sat_in_box'

    teamState = this.getTeamStateAttributes(jamIndex, team)

    if statusIndex >= teamState.lineupStatusStatesAttributes.length
      teamState.lineupStatusStatesAttributes[statusIndex] = {pivot: 'clear', blocker1: 'clear', blocker2: 'clear', blocker3: 'clear', jammer: 'clear' }

    if not teamState.lineupStatusStatesAttributes[statusIndex][position]
      teamState.lineupStatusStatesAttributes[statusIndex][position] = 'clear'

    teamState.lineupStatusStatesAttributes[statusIndex][position] = transition[teamState.lineupStatusStatesAttributes[statusIndex][position]]
    this.setState(this.state)
    this.syncState()

  setSelectorContext: (jamIndex, team, position) ->
    this.state.selectorContext = 
      roster: this.getTeamAttributes(team).rosterAttributes
      buttonHandler: this.selectSkater.bind(this, jamIndex, team, position)
      style: this.getTeamAttributes(team).colorBarStyle
    this.setState(this.state)

  selectSkater: (jamIndex, team, position, rosterIndex) ->
    this.pushState()
    teamState = this.getTeamStateAttributes(jamIndex, team)
    teamAttributes = this.getTeamAttributes(team)
    teamState[position+'Number'] = teamAttributes.rosterAttributes[rosterIndex].number
    this.setState(this.state)
    this.syncState()

  render: () ->
    homeActiveTeamClass = cx
      'home': true
      'hidden-xs': !this.props.homeAttributes.isSelected

    awayActiveTeamClass = cx
      'away': true
      'hidden-xs': !this.props.awayAttributes.isSelected

    <div className="lineup-tracker">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.props.awayAttributes.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.props.awayAttributes.name}
          </div>
        </div>
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.props.homeAttributes.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.props.homeAttributes.name}
          </div>
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
      {this.state.lineupStatesAttributes.map (lineupState, jamIndex) ->
          <div className="row gutters-xs jam-details" key={jamIndex}>
            <div className="col-sm-6 col-xs-12" id="away-team">
              <JamDetail
                teamAttributes={this.props.awayAttributes}
                jamNumber={lineupState.jamNumber}
                data={lineupState.awayStateAttributes}
                noPivotHandler={this.toggleNoPivot.bind(this, jamIndex, 'away')}
                starPassHandler={this.toggleStarPass.bind(this, jamIndex, 'away')}
                boxHandler={this.toggleBox.bind(this, jamIndex, 'away')}
                setSelectorContextHandler={this.setSelectorContext.bind(this, jamIndex, 'away')}
                selectSkaterHandler={this.selectSkater.bind(this, jamIndex, 'away')} />
            </div>
            <div className="col-sm-6 col-xs-12 hidden-xs" id="home-team">
              <JamDetail
                teamAttributes={this.props.homeAttributes}
                jamNumber={lineupState.jamNumber}
                data={lineupState.homeStateAttributes}
                noPivotHandler={this.toggleNoPivot.bind(this, jamIndex, 'home')}
                starPassHandler={this.toggleStarPass.bind(this, jamIndex, 'home')}
                boxHandler={this.toggleBox.bind(this, jamIndex, 'home')}
                setSelectorContextHandler={this.setSelectorContext.bind(this, jamIndex, 'home')}
                selectSkaterHandler={this.selectSkater.bind(this, jamIndex, 'home')} />
            </div>
          </div>
      , this}
      <div className="row gutters-xs actions">
        <div className="col-sm-6 col-xs-6">
          <button className="actions-action actions-edit text-center btn btn-block" onClick={this.endJam}>
            END
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="actions-action actions-undo text-center btn btn-block" onClick={this.undo}>
            <strong>UNDO</strong>
          </button>
        </div>
      </div>
      <SkaterSelectorDialog roster={this.state.selectorContext.roster} buttonHandler={this.state.selectorContext.buttonHandler} style={this.state.selectorContext.style} />
    </div>

exports.JamDetail = React.createClass
  propTypes:
    teamAttributes: React.PropTypes.any.isRequired
    jamNumber: React.PropTypes.number.isRequired
    data: React.PropTypes.any.isRequired
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
      'selected': this.props.data.noPivot

    starPassButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-star-pass': true
      'toggle-star-pass-btn': true
      'selected': this.props.data.starPass

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
                Jam {this.props.jamNumber}
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
          <SkaterSelector number={this.props.data.pivotNumber} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "pivot")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.blocker1Number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker1")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.blocker2Number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker2")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.blocker3Number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker3")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.jammerNumber} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "jammer")} />
        </div>
      </div>
      {this.props.data.lineupStatusStatesAttributes.map (row, rowIndex) ->
        <LineupBoxRow key={rowIndex} data={row} boxHandler={this.props.boxHandler.bind(this, rowIndex)} /> 
      , this }
      <LineupBoxRow key={this.props.data.lineupStatusStatesAttributes.length} boxHandler={this.props.boxHandler.bind(this, this.props.data.lineupStatusStatesAttributes.length)} />
    </div>

exports.SkaterSelector = React.createClass
  propTypes:
    number: React.PropTypes.string
    style: React.PropTypes.object
    buttonHandler: React.PropTypes.func.isRequired

  buttonContent: () ->
    if this.props.number
      this.props.number
    else
      <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>


  render: () ->
    <button className="skater-selector text-center btn btn-block" data-toggle="modal" style={if this.props.number then this.props.style else {}} data-target="#roster-modal" onClick={this.props.buttonHandler}>
      <strong>{this.buttonContent()}</strong>
    </button>

exports.SkaterSelectorDialog = React.createClass
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
  getDefaultProps: () ->
    data:
      pivot: 'clear'
      blocker1: 'clear'
      blocker2: 'clear'
      blocker3: 'clear'
      jammer: 'clear'

  render: () ->
    <div className="row gutters-xs boxes">
        <div className="col-sm-2 col-xs-2 col-sm-offest-2 col-xs-offset-2">
          <LineupBox status={this.props.data.pivot} boxHandler={this.props.boxHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.blocker1} boxHandler={this.props.boxHandler.bind(this, 'blocker1')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.blocker2} boxHandler={this.props.boxHandler.bind(this, 'blocker2')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.blocker3} boxHandler={this.props.boxHandler.bind(this, 'blocker3')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.jammer} boxHandler={this.props.boxHandler.bind(this, 'jammer')} />
        </div>
      </div>


exports.LineupBox = React.createClass
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

