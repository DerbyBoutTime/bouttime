cx = React.addons.classSet
exports = exports ? this

exports.PassItem = React.createClass
  displayName: 'PassItem'
  propType:
    passState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired

  decrementPassNumber: () ->
    passNumber = this.props.passState.passNumber
    if passNumber > 1
      this.props.actions.setPassNumber(passNumber - 1)

  incrementPassNumber: () ->
    passNumber = this.props.passState.passNumber
    this.props.actions.setPassNumber(passNumber + 1)

  render: () ->
    injuryClass = cx
      'selected': this.props.passState.injury
      'notes': true
      'injury': true
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

    editPassNumberId = "edit-pass-number#{exports.wftda.functions.uniqueId()}"
    editPassId = "edit-pass-#{exports.wftda.functions.uniqueId()}"

    <div aria-multiselectable="true">
      <div className="columns">
        <div className="row gutters-xs">
          <div className="col-sm-2 col-xs-2">
            <button className="pass btn btn-block" data-toggle="collapse" data-target={"##{editPassNumberId}"} aria-expanded="false" aria-controls={editPassNumberId} >
              {this.props.passState.passNumber}
            </button>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className="skater">
              Skater
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className={injuryClass}>
              Injury
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className={callClass}>
              Call
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className={lostClass}>
              Lost
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <button className="points btn btn-block" data-toggle="collapse" data-target={"##{editPassId}"} aria-expanded="false" aria-controls={editPassId} >
              {this.props.passState.points || 0}
            </button>
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
              <div className="minus text-center" onClick={this.decrementPassNumber}>
                <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="plus text-center" onClick={this.incrementPassNumber}>
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
      <PassEditPanel {...this.props} editPassId={editPassId}/>
    </div>
