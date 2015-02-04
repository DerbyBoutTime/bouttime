exports = exports ? this
exports.PassEditPanel = React.createClass
  render: () ->
    if this.props.pass.passNumber == 1
      return(
        <div className="panel">
          <div className="edit-pass first-pass collapse" id={this.props.editPassId}>
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes injury text-center">
                  Injury
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes note-lead text-center">
                  Lead
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes call text-center">
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
                <div className="zero text-center">
                  0
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="one text-center">
                  1
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes no-pass text-center">
                  No P.
                </div>
              </div>
            </div>
          </div>
        </div>
      )
    else
      return(
        <div className="panel">
          <div className="edit-pass second-pass collapse" id={this.props.editPassId}>
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes injury text-center">
                  Injury
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes note-lead text-center">
                  Lead
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes call text-center">
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
                <div className="zero text-center">
                  0
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="one text-center">
                  1
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="two text-center">
                  2
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="three text-center">
                  3
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="four text-center">
                  4
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="five text-center">
                  5
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="six text-center">
                  6
                </div>
              </div>
            </div>
          </div>
        </div>
      )
