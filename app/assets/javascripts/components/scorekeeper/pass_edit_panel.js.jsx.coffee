cx = React.addons.classSet
exports = exports ? this
exports.PassEditPanel = React.createClass
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      passNumber: this.props.pass.passNumber
      team: this.props.teamType
      jamNumber: this.props.jamNumber
      state: this.state
    $.extend(std_opts, opts)

  toggleInjury: (e) ->
    this.state.pass.injury = !this.state.pass.injury
    dispatcher.trigger "scorekeeper.toggle_injury", this.getStandardOptions()

  toggleNopass: (e) ->
    this.state.pass.nopass = !this.state.pass.nopass
    dispatcher.trigger "scorekeeper.toggle_nopass", this.getStandardOptions()

  toggleCalloff: (e) ->
    this.state.pass.calloff = !this.state.pass.calloff
    dispatcher.trigger "scorekeeper.toggle_calloff", this.getStandardOptions()

  toggleLostLead: (e) ->
    this.state.pass.lostLead = !this.state.pass.lostLead
    dispatcher.trigger "scorekeeper.toggle_lost_lead", this.getStandardOptions()

  toggleLead: (e) ->
    this.state.pass.lead = !this.state.pass.lead
    dispatcher.trigger "scorekeeper.toggle_lead", this.getStandardOptions()

  handleSetPoints: (points) ->
    this.state.pass.points = points
    dispatcher.trigger "scorekeeper.set_points", this.getStandardOptions(points: points)
    this.props.updateTeamPoints(this.props.teamType)

  getInitialState: () ->
    this.state = this.props
    this.state

  render: () ->
    injuryClass = cx
      'selected': this.state.pass.injury
      'notes': true
      'injury': true
      'text-center': true
    nopassClass = cx
      'selected': this.state.pass.nopass
      'notes': true
      'no-pass': true
      'text-center': true
    callClass = cx
      'selected': this.state.pass.calloff
      'notes': true
      'call': true
      'text-center': true
    lostClass = cx
      'selected': this.state.pass.lostLead
      'notes': true
      'lost': true
      'text-center': true
    leadClass = cx
      'selected': this.state.pass.lead
      'notes': true
      'note-lead': true
      'text-center': true
    zeroClass = cx
      'zero': true
      'text-center': true
      'selected': this.state.pass.points == 0
    oneClass = cx
      'one': true
      'text-center': true
      'selected': this.state.pass.points == 1
    twoClass = cx
      'two': true
      'text-center': true
      'selected': this.state.pass.points == 2
    threeClass = cx
      'three': true
      'text-center': true
      'selected': this.state.pass.points == 3
    fourClass = cx
      'four': true
      'text-center': true
      'selected': this.state.pass.points == 4
    fiveClass = cx
      'five': true
      'text-center': true
      'selected': this.state.pass.points == 5
    sixClass = cx
      'six': true
      'text-center': true
      'selected': this.state.pass.points == 6


    if this.props.pass.passNumber == 1
      return(
        `<div className="panel">
          <div className="edit-pass first-pass collapse" id={this.props.editPassId}>
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={injuryClass} onClick={this.toggleInjury}>
                  Injury
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={leadClass} onClick={this.toggleLead}>
                  Lead
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={callClass} onClick={this.toggleCalloff}>
                  Call
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="ok text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                </div>
              </div>
            </div>
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-3 col-xs-offset-3">
                <div className={zeroClass} onClick={this.handleSetPoints.bind(this, 0)}>
                  0
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={oneClass} onClick={this.handleSetPoints.bind(this, 1)}>
                  1
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={nopassClass} onClick={this.toggleNopass}>
                  No P.
                </div>
              </div>
            </div>
          </div>
        </div>`
      )
    else
      return(
        `<div className="panel">
          <div className="edit-pass second-pass collapse" id={this.props.editPassId}>
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={injuryClass} onClick={this.toggleInjury}>
                  Injury
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={lostClass} onClick={this.toggleLostLead}>
                  Lost
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className={callClass} onClick={this.toggleCalloff}>
                  Call
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="ok text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                </div>
              </div>
            </div>
            <div className="row gutters-xs">
              <div className="col-sm-1 col-xs-1 col-sm-offset-2 col-xs-offset-2">
                <div className={zeroClass} onClick={this.handleSetPoints.bind(this, 0)}>
                  0
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className={oneClass} onClick={this.handleSetPoints.bind(this, 1)}>
                  1
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className={twoClass} onClick={this.handleSetPoints.bind(this, 2)}>
                  2
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className={threeClass} onClick={this.handleSetPoints.bind(this, 3)}>
                  3
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className={fourClass} onClick={this.handleSetPoints.bind(this, 4)}>
                  4
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className={fiveClass} onClick={this.handleSetPoints.bind(this, 5)}>
                  5
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className={sixClass} onClick={this.handleSetPoints.bind(this, 6)}>
                  6
                </div>
              </div>
            </div>
          </div>
        </div>`
      )
