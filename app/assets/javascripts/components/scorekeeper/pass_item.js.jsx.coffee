cx = React.addons.classSet
exports = exports ? this
exports.SelectRoster = React.createClass
  getStandardOptions: (opts = {}) ->
    std_opts =
      time: new Date()
      role: 'Scorekeeper'
      passNumber: this.props.pass.passNumber
      team: this.props.teamType
      jamNumber: this.props.jamNumber
      state: this.state
    $.extend(std_opts, opts)

  handleSelection: (e) ->
    skaterNumber = e.target.value
    this.state.pass.skaterNumber = skaterNumber
    dispatcher.trigger "scorekeeper.set_jammer", this.getStandardOptions(skaterNumber: skaterNumber)

  getInitialState: () ->
    this.state = this.props
    this.state.options = []
    this.state

  componentDidMount: () ->
    this.state.options.push(`<option key={"null"} value="__blank">Skater</option>`)
    this.props.roster.map (skater) =>
      this.state.options.push(`<option key={skater.number} value={skater.number}>{skater.name}</option>`)

  render: () ->
    `<select className="form-control" value={this.state.pass.skaterNumber} onChange={this.handleSelection}>
      {this.state.options}
    </select>`

exports.PassItem = React.createClass
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
    # this.setState(this.state)
    dispatcher.trigger "scorekeeper.toggle_injury", this.getStandardOptions()

  toggleCalloff: (e) ->
    this.state.pass.calloff = !this.state.pass.calloff
    # this.setState(this.state)
    dispatcher.trigger "scorekeeper.toggle_calloff", this.getStandardOptions()

  toggleLostLead: (e) ->
    this.state.pass.lostLead = !this.state.pass.lostLead
    # this.setState(this.state)
    dispatcher.trigger "scorekeeper.toggle_lost_lead", this.getStandardOptions()

  getInitialState: () ->
    this.state = this.props
    this.state.options = []
    this.state

  render: () ->
    nodeId = "#{this.props.teamType}-team-pass-#{this.props.pass.passNumber}"
    jqNodeId = "##{nodeId}"

    editPassNumberId = "#{this.props.teamType}-team-edit-pass-number-#{this.props.pass.passNumber}"
    jqEditPassNumberId = "##{editPassNumberId}"

    editPassId = "#{this.props.teamType}-team-edit-pass-#{this.props.pass.passNumber}"
    jqEditPassId = "##{editPassId}"

    injuryClass = cx
      'selected': this.state.pass.injury
      'notes': true
      'injury': true
      'text-center': true
    callClass = cx
      'selected': this.state.pass.calloff
      'notes': true
      'call': true
      'text-center': true
    callLost = cx
      'selected': this.state.pass.lostLead
      'notes': true
      'lost': true
      'text-center': true

    `<div aria-multiselectable="true" id={nodeId}>
      <div className="columns">
        <div className="row gutters-xs">
          <div className="col-sm-2 col-xs-2">
            <div aria-controls={jqEditPassNumberId} aria-expanded="false" className="pass text-center" data-parent={jqNodeId} data-toggle="collapse" href={jqEditPassNumberId}>
              {this.props.pass.passNumber}
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className="skater">
              <SelectRoster {...this.props} />
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className={injuryClass} onClick={this.toggleInjury}>
              Injury
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className={callClass} onClick={this.toggleCalloff}>
              Call
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className={callLost} onClick={this.toggleLostLead}>
              Lost
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div aria-controls={jqEditPassId} aria-expanded="false" className="points text-center" data-parent={jqNodeId} data-toggle="collapse" href={jqEditPassId}>
              {this.props.pass.points || 0}
            </div>
          </div>
        </div>
      </div>
      <div className="panel">
        <div className="edit-pass-number collapse" id={editPassNumberId}>
          <div className="row gutters-xs">
            <div className="col-sm-1 col-xs-1">
              <div className="remove text-center">
                <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="minus text-center">
                <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="plus text-center">
                <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className="ok text-center">
                <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
              </div>
            </div>
          </div>
        </div>
      </div>
      <PassEditPanel pass={this.props.pass} teamType={this.props.teamType} editPassId={editPassId}/>
    </div>`
