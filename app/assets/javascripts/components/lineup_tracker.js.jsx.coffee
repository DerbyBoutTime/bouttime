cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    this.state_stack = []
    state = 
      jam_details: [this.getNewJam(1)]
      selector_context:
        roster: []
        buttonHandler: this.selectSkater.bind(this, 0, 'away', 'pivot')

  push_state: () ->
    this.state_stack.push($.extend(true, {}, this.state))

  undo: () ->
    previous_state = this.state_stack.pop()
    if previous_state
      this.state = previous_state
      this.setState(this.state)

  getNewJam: (jam_number) ->
    jam_number: jam_number
    jam_ended: false
    home_detail:
      no_pivot: false
      star_pass: false
      pivot_number: null
      blocker_1_number: null
      blocker_2_number: null
      blocker_3_number: null
      jammer_number: null
      boxes: []
    away_detail:
      no_pivot: false
      star_pass: false
      pivot_number: null
      blocker_1_number: null
      blocker_2_number: null
      blocker_3_number: null
      jammer_number: null
      boxes: []

  endJam: (jam_index) ->
    this.push_state()
    jam = this.state.jam_details[jam_index]
    jam.jam_ended = true
    new_jam = this.getNewJam(jam.jam_number + 1)
    positions_in_box = this.positions_in_box(jam)
    for team in ['away_detail', 'home_detail']
      if positions_in_box[team].length > 0
        new_jam[team].boxes[0] = {}
        for position in positions_in_box[team]
          new_jam[team][position+'_number'] = jam[team][position+'_number']
          new_jam[team].boxes[0][position] = 'sat_in_box'
    this.state.jam_details.push(new_jam)
    this.setState(this.state)

  positions_in_box: (jam) ->
    positions =
      home_detail: []
      away_detail:[]
    for team in ['away_detail', 'home_detail']
      detail = jam[team]
      for row in detail.boxes
        for position, status of row
          positions[team].push(position) if status in ['went_to_box', 'sat_in_box']
    positions


  getTeamDetail: (jam_index, team) ->
    switch team
      when 'away' then this.state.jam_details[jam_index].away_detail
      when 'home' then this.state.jam_details[jam_index].home_detail

  getTeamAttributes: (team) ->
    switch team
      when 'away' then this.props.awayAttributes
      when 'home' then this.props.homeAttributes

  toggleNoPivot: (jam_index, team) ->
    this.push_state()
    team_detail = this.getTeamDetail(jam_index, team)
    team_detail.no_pivot = !team_detail.no_pivot
    this.setState(this.state)

  toggleStarPass: (jam_index, team) ->
    this.push_state()
    team_detail = this.getTeamDetail(jam_index, team)
    team_detail.star_pass = !team_detail.star_pass
    this.setState(this.state)

  toggleBox: (jam_index, team, box_index, position) ->
    this.push_state()
    transition = 
      'clear': 'went_to_box'
      'went_to_box': 'went_to_box_and_released'
      'went_to_box_and_released': 'injured'
      'injured': 'clear'
      'sat_in_box': 'sat_in_box_and_released'
      'sat_in_box_and_released': 'sat_in_box'

    team_detail = this.getTeamDetail(jam_index, team)

    if box_index >= team_detail.boxes.length
      team_detail.boxes[box_index] = {}

    if not team_detail.boxes[box_index][position]
      team_detail.boxes[box_index][position] = 'clear'

    team_detail.boxes[box_index][position] = transition[team_detail.boxes[box_index][position]]
    this.setState(this.state)

  setSelectorContext: (jam_index, team, position) ->
    this.state.selector_context = 
      roster: this.getTeamAttributes(team).rosterAttributes
      button_handler: this.selectSkater.bind(this, jam_index, team, position)
      style: this.getTeamAttributes(team).colorBarStyle
    this.setState(this.state)

  selectSkater: (jam_index, team, position, roster_index) ->
    this.push_state()
    team_detail = this.getTeamDetail(jam_index, team)
    team_attributes = this.getTeamAttributes(team)
    team_detail[position+'_number'] = team_attributes.rosterAttributes[roster_index].number
    this.setState(this.state)

  render: () ->
    homeActiveTeamClass = cx
      'home': true
      'hidden-xs': !this.props.homeAttributes.isSelected

    awayActiveTeamClass = cx
      'away': true
      'hidden-xs': !this.props.awayAttributes.isSelected

    `<div className="lineup-tracker">
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
      {this.state.jam_details.map(function(jam_detail, jam_index){
        return (
          <div className="row gutters-xs jam-details" key={jam_index}>
            <div className="col-sm-6 col-xs-12" id="away-team">
              <JamDetail
                teamAttributes={this.props.awayAttributes}
                jamNumber={jam_detail.jam_number}
                jamEnded={jam_detail.jam_ended}
                data={jam_detail.away_detail}
                noPivotHandler={this.toggleNoPivot.bind(this, jam_index, 'away')}
                starPassHandler={this.toggleStarPass.bind(this, jam_index, 'away')}
                boxHandler={this.toggleBox.bind(this, jam_index, 'away')}
                undoHandler={this.undo}
                endHandler={this.endJam.bind(this, jam_index)} 
                setSelectorContextHandler={this.setSelectorContext.bind(this, jam_index, 'away')}
                selectSkaterHandler={this.selectSkater.bind(this, jam_index, 'away')} />
            </div>
            <div className="col-sm-6 col-xs-12 hidden-xs" id="home-team">
              <JamDetail
                teamAttributes={this.props.homeAttributes}
                jamNumber={jam_detail.jam_number}
                jamEnded={jam_detail.jam_ended}
                data={jam_detail.home_detail}
                noPivotHandler={this.toggleNoPivot.bind(this, jam_index, 'home')}
                starPassHandler={this.toggleStarPass.bind(this, jam_index, 'home')}
                boxHandler={this.toggleBox.bind(this, jam_index, 'home')}
                undoHandler={this.undo}
                endHandler={this.endJam.bind(this, jam_index)} 
                setSelectorContextHandler={this.setSelectorContext.bind(this, jam_index, 'home')}
                selectSkaterHandler={this.selectSkater.bind(this, jam_index, 'home')} />
            </div>
          </div>
        )
      }, this)}
      <SkaterSelectorDialog roster={this.state.selector_context.roster} buttonHandler={this.state.selector_context.button_handler} style={this.state.selector_context.style} />
    </div>`

exports.JamDetail = React.createClass
  propTypes:
    teamAttributes: React.PropTypes.any.isRequired
    jamNumber: React.PropTypes.number.isRequired
    jamEnded: React.PropTypes.bool.isRequired
    data: React.PropTypes.any.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    boxHandler: React.PropTypes.func.isRequired
    undoHandler: React.PropTypes.func.isRequired
    endHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired

  render: () ->
    noPivotButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-no-pivot': true
      'toggle-pivot-btn': true
      'selected': this.props.data.no_pivot

    starPassButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-star-pass': true
      'toggle-star-pass-btn': true
      'selected': this.props.data.star_pass

    actionsClass = cx
      'row': true
      'gutters-xs': true
      'actions': true
      'hidden': this.props.jamEnded

    `<div>
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
          <SkaterSelector number={this.props.data.pivot_number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "pivot")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.blocker_1_number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker_1")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.blocker_2_number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker_2")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.blocker_3_number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "blocker_3")} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector number={this.props.data.jammer_number} style={this.props.teamAttributes.colorBarStyle} buttonHandler={this.props.setSelectorContextHandler.bind(this, "jammer")} />
        </div>
      </div>
      {this.props.data.boxes.map(function(row, row_index) {
        return (
          <LineupBoxRow key={row_index} data={row} boxHandler={this.props.boxHandler.bind(this, row_index)} />
        )
      }, this)}
      <LineupBoxRow key={this.props.data.boxes.length} boxHandler={this.props.boxHandler.bind(this, this.props.data.boxes.length)} />
      <div className={actionsClass}>
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
    </div>`

exports.SkaterSelector = React.createClass
  propTypes:
    number: React.PropTypes.string
    style: React.PropTypes.object
    buttonHandler: React.PropTypes.func.isRequired

  buttonContent: () ->
    if this.props.number
      this.props.number
    else
      `<span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>`


  render: () ->
    `<button className="skater-selector text-center btn btn-block" data-toggle="modal" style={this.props.number ? this.props.style : {}} data-target="#roster-modal" onClick={this.props.buttonHandler}>
      <strong>{this.buttonContent()}</strong>
    </button>`

exports.SkaterSelectorDialog = React.createClass
  propTypes:
    roster: React.PropTypes.array.isRequired
    buttonHandler: React.PropTypes.func
    style: React.PropTypes.object

  render: () ->
    `<div className="modal fade" id="roster-modal">
      <div className="modal-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal"><span>&times;</span></button>
            <h4 className="modal-title">Select Skater</h4>
          </div>
          <div className="modal-body">
            {this.props.roster.map(function(skater, roster_index){
              return(
                <button key={roster_index} className="btn btn-block" style={this.props.style} data-dismiss="modal" onClick={this.props.buttonHandler.bind(this, roster_index)}><strong>{skater.name} - {skater.number}</strong></button>
              )
            }, this)}
          </div>
        </div>
      </div>
    </div>`

exports.LineupBoxRow = React.createClass
  getDefaultProps: () ->
    data:
      pivot: 'clear'
      blocker_1: 'clear'
      blocker_2: 'clear'
      blocker_3: 'clear'
      jammer: 'clear'

  render: () ->
    `<div className="row gutters-xs boxes">
        <div className="col-sm-2 col-xs-2 col-sm-offest-2 col-xs-offset-2">
          <LineupBox status={this.props.data.pivot} boxHandler={this.props.boxHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.blocker_1} boxHandler={this.props.boxHandler.bind(this, 'blocker_1')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.blocker_2} boxHandler={this.props.boxHandler.bind(this, 'blocker_2')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.blocker_3} boxHandler={this.props.boxHandler.bind(this, 'blocker_3')} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <LineupBox status={this.props.data.jammer} boxHandler={this.props.boxHandler.bind(this, 'jammer')} />
        </div>
      </div>`


exports.LineupBox = React.createClass
  propTypes:
    status: React.PropTypes.string

  getDefaultProps: () ->
    status: 'clear'

  render: () ->
    mapping = 
      'clear': `<span>&nbsp;</span>`
      'went_to_box': '/'
      'went_to_box_and_released': 'X'
      'injured': `<span className="glyphicon glyphicon-paperclip"></span>`
      'sat_in_box': 'S'
      'sat_in_box_and_released': '$'

    `<button className="box text-center btn btn-block btn-box" onClick={this.props.boxHandler}>
      <strong>{mapping[this.props.status]}</strong>
    </button>`


