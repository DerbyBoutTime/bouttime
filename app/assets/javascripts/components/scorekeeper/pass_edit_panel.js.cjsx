cx = React.addons.classSet
exports = exports ? this
exports.PassEditPanel = React.createClass
  displayName: 'PassEditPanel'
  setPoints: (points) ->
    this.props.actions.setPoints(points)
    $("##{this.props.editPassId}").collapse('hide')
  render: () ->
    injuryClass = cx
      'btn btn-block notes injury': true
      'selected': this.props.passState.injury
    nopassClass = cx
      'btn btn-block notes no-pass': true
      'selected': this.props.passState.nopass
    callClass = cx
      'btn btn-block notes call': true
      'selected': this.props.passState.calloff
    lostClass = cx
      'btn btn-block notes lost': true
      'selected': this.props.passState.lostLead
    leadClass = cx
      'btn btn-block notes note-lead': true
      'selected': this.props.passState.lead
    zeroClass = cx
      'btn btn-block scores zero': true
      'selected': this.props.passState.points == 0
    oneClass = cx
      'btn btn-block scores one': true
      'selected': this.props.passState.points == 1
    twoClass = cx
      'btn btn-block scores two': true
      'selected': this.props.passState.points == 2
    threeClass = cx
      'btn btn-block scores three': true
      'selected': this.props.passState.points == 3
    fourClass = cx
      'btn btn-block scores four': true
      'selected': this.props.passState.points == 4
    fiveClass = cx
      'btn btn-block scores five': true
      'selected': this.props.passState.points == 5
    sixClass = cx
      'btn btn-block scores six': true
      'selected': this.props.passState.points == 6
    if this.props.passState.passNumber == 1
      <div className="panel">
        <div className="edit-pass first-pass collapse" id={this.props.editPassId}>
          <div className="row gutters-xs">
            <div className="col-sm-4 col-xs-4">
              <button className={injuryClass} onClick={this.props.actions.toggleInjury}>
                <strong>Injury</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={leadClass} onClick={this.props.actions.toggleLead}>
                <strong>Lead</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={callClass} onClick={this.props.actions.toggleCalloff}>
                <strong>Call</strong>
              </button>
            </div>
          </div>
          <div className="row gutters-xs">
            <div className="col-sm-4 col-xs-4">
              <button className={zeroClass} onClick={this.setPoints.bind(this, 0)}>
                <strong>0</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={oneClass} onClick={this.setPoints.bind(this, 1)}>
                <strong>1</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={nopassClass} onClick={this.props.actions.toggleNopass}>
                <strong>No P.</strong>
              </button>
            </div>
          </div>
        </div>
      </div>
    else
      <div className="panel">
        <div className="edit-pass second-pass collapse" id={this.props.editPassId}>
          <div className="row gutters-xs">
            <div className="col-sm-4 col-xs-4">
              <button className={injuryClass} onClick={this.props.actions.toggleInjury}>
                <strong>Injury</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={lostClass} onClick={this.props.actions.toggleLostLead}>
                <strong>Lost</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={callClass} onClick={this.props.actions.toggleCalloff}>
                <strong>Call</strong>
              </button>
            </div>
          </div>
          <div className="row gutters-xs">
            <div className="col-sm-11 col-xs-11">
              <div className="row gutters-xs">
                <div className="col-sm-2 col-xs-2">
                  <button className={zeroClass} onClick={this.setPoints.bind(this, 0)}>
                    <strong>0</strong>
                  </button>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <button className={oneClass} onClick={this.setPoints.bind(this, 1)}>
                    <strong>1</strong>
                  </button>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <button className={twoClass} onClick={this.setPoints.bind(this, 2)}>
                    <strong>2</strong>
                  </button>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <button className={threeClass} onClick={this.setPoints.bind(this, 3)}>
                    <strong>3</strong>
                  </button>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <button className={fourClass} onClick={this.setPoints.bind(this, 4)}>
                    <strong>4</strong>
                  </button>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <button className={fiveClass} onClick={this.setPoints.bind(this, 5)}>
                    <strong>5</strong>
                  </button>
                </div>
              </div>
            </div>
            <div className="col-sm-1 col-xs-1">
              <button className={sixClass} onClick={this.setPoints.bind(this, 6)}>
                <strong>6</strong>
              </button>
            </div>
          </div>
        </div>
      </div>
