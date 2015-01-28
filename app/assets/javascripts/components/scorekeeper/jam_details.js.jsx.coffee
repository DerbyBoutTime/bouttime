cx = React.addons.classSet
exports = exports ? this
exports.JamDetails = React.createClass
  totalPoints: () ->
    points = 0
    this.props.jam.passStates.map (pass) =>
      points += pass.points
    return points

  getInitialState: () ->
    this.state = this.props

  componentWillReceiveProps: (props) ->
    # ...

  render: () ->
    nodeId = "#{this.props.teamType}-team-jam-#{this.props.jam.jamNumber}-details"
    jqNodeId = "##{nodeId}"
    jamDetailsClassName = cx
      'hidden-xs': this.props.jamSelected != this.props.jam.jamNumber

    return(
      `<div  className={jamDetailsClassName}>
          <div className="links">
            <div className="row text-center gutters-xs">
              <div className="col-sm-6 col-xs-6">
                <div className="link main-menu" onClick={this.props.mainMenuHandler}>
                  MAIN MENU
                </div>
              </div>
              <div className="col-sm-6 col-xs-6">
                <div className="row gutters-xs">
                  <div className="col-sm-5 col-xs-5 col-sm-offset-1 col-xs-offset-1">
                    <div className="link prev" onClick={this.props.prevJamHandler}>
                      PREV
                    </div>
                  </div>
                  <div className="col-sm-6 col-xs-6">
                    <div className="link next" onClick={this.props.nextJamHandler}>
                      NEXT
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="jam-details">
            <div className="row gutters-xs">
              <div className="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
                <div className="jam-number">
                  <strong>Jam {this.props.jam.jamNumber}</strong>
                </div>
              </div>
              <div className="col-sm-3 col-xs-3 text-right">
                <div className="jam-total-score">
                  <strong>{this.totalPoints()}</strong>
                </div>
              </div>
            </div>
          </div>
          <PassesList jamNumber={this.props.jam.jamNumber} passes={this.props.jam.passStates} teamType={this.props.teamType} roster={this.props.roster} updateTeamPoints={this.props.updateTeamPoints} />
      </div>`
    )
