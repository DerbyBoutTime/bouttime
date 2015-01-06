exports = exports ? this
exports.JamItem = React.createClass
  render: () ->
    return(
      `<div className="row gutters-xs">
        <div className="col-sm-2 col-xs-2">
          <div className="jam text-center">
            {this.props.number}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="skater">
            {this.props.skater}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="notes injury text-center">
            Injury
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="notes call text-center">
            Call
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="notes lost text-center">
            Lost
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="points text-center">
            10
          </div>
        </div>
      </div>`
    )
