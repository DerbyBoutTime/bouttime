cx = React.addons.classSet
exports = exports ? this
exports.JamItem = React.createClass
  displayName: 'JamItem'
  propTypes:
    jamState: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
    updateTeamPoints: React.PropTypes.func

  render: () ->
    <div>
      <div className="row gutters-xs" onClick={this.props.selectionHandler} >
        <div className="col-sm-2 col-xs-2">
          <div className="jam text-center">
            {this.props.jamState.jamNumber}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="skater">
            Skater
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
            {this.props.jamState.points || 0}
          </div>
        </div>
      </div>
    </div>
