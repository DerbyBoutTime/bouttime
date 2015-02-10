cx = React.addons.classSet
exports = exports ? this
exports.JamItem = React.createClass
  getInitialState: () ->
    this.state = this.props

  render: () ->
    nodeId = "#{this.props.teamType}-team-jam-#{this.props.jam.jamNumber}"
    jqNodeId = "##{nodeId}"
    jamRowClassName = cx
      'hidden-xs': this.props.jamSelected
      'row gutters-xs': true

    return(
      <div>
        <div className={jamRowClassName} id={nodeId} onClick={this.props.selectionHandler} >
          <div className="col-sm-2 col-xs-2">
            <div className="jam text-center">
              {this.props.jam.jamNumber}
            </div>
          </div>
          <div className="col-sm-2 col-xs-2">
            <div className="skater">
              {this.props.jam.skaterNumber}
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
        </div>
        <JamDetails jam={this.props.jam} roster={this.props.roster} jamSelected={this.props.jamSelected} teamType={this.props.teamType} mainMenuHandler={this.props.mainMenuHandler} nextJamHandler={this.props.nextJamHandler} prevJamHandler={this.props.prevJamHandler} updateTeamPoints={this.props.updateTeamPoints} />
        {### depending on the team and jam selected pass in the jam as props ###}
      </div>
    )
