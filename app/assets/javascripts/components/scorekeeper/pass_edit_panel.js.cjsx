cx = React.addons.classSet
exports = exports ? this
exports.PassEditPanel = React.createClass
  render: () ->
    injuryClass = cx
      'selected': this.props.passState.injury
      'notes': true
      'injury': true
      'text-center': true
    nopassClass = cx
      'selected': this.props.passState.nopass
      'notes': true
      'no-pass': true
      'text-center': true
    callClass = cx
      'selected': this.props.passState.calloff
      'notes': true
      'call': true
      'text-center': true
    lostClass = cx
      'selected': this.props.passState.lostLead
      'notes': true
      'lost': true
      'text-center': true
    leadClass = cx
      'selected': this.props.passState.lead
      'notes': true
      'note-lead': true
      'text-center': true
    zeroClass = cx
      'zero': true
      'text-center': true
      'selected': this.props.passState.points == 0
    oneClass = cx
      'one': true
      'text-center': true
      'selected': this.props.passState.points == 1
    twoClass = cx
      'two': true
      'text-center': true
      'selected': this.props.passState.points == 2
    threeClass = cx
      'three': true
      'text-center': true
      'selected': this.props.passState.points == 3
    fourClass = cx
      'four': true
      'text-center': true
      'selected': this.props.passState.points == 4
    fiveClass = cx
      'five': true
      'text-center': true
      'selected': this.props.passState.points == 5
    sixClass = cx
      'six': true
      'text-center': true
      'selected': this.props.passState.points == 6


    if this.props.passState.passNumber == 1
      <div className="panel">
        <div className="edit-pass first-pass collapse" id={this.props.editPassId}>
          <div className="row gutters-xs">
            <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
              <div className="remove text-center">
                <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={injuryClass} onClick={this.props.actions.toggleInjury}>
                Injury
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={leadClass} onClick={this.props.actions.toggleLead}>
                Lead
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={callClass} onClick={this.props.actions.toggleCalloff}>
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
              <div className={zeroClass} onClick={this.props.actions.setPoints.bind(this, 0)}>
                0
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={oneClass} onClick={this.props.actions.setPoints.bind(this, 1)}>
                1
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={nopassClass} onClick={this.props.actions.toggleNopass}>
                No P.
              </div>
            </div>
          </div>
        </div>
      </div>
    else
      <div className="panel">
        <div className="edit-pass second-pass collapse" id={this.props.editPassId}>
          <div className="row gutters-xs">
            <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
              <div className="remove text-center">
                <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={injuryClass} onClick={this.props.actions.toggleInjury}>
                Injury
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={lostClass} onClick={this.props.actions.toggleLostLead}>
                Lost
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className={callClass} onClick={this.props.actions.toggleCalloff}>
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
              <div className={zeroClass} onClick={this.props.actions.setPoints.bind(this, 0)}>
                0
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className={oneClass} onClick={this.props.actions.setPoints.bind(this, 1)}>
                1
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className={twoClass} onClick={this.props.actions.setPoints.bind(this, 2)}>
                2
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className={threeClass} onClick={this.props.actions.setPoints.bind(this, 3)}>
                3
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className={fourClass} onClick={this.props.actions.setPoints.bind(this, 4)}>
                4
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className={fiveClass} onClick={this.props.actions.setPoints.bind(this, 5)}>
                5
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <div className={sixClass} onClick={this.props.actions.setPoints.bind(this, 6)}>
                6
              </div>
            </div>
          </div>
        </div>
      </div>
