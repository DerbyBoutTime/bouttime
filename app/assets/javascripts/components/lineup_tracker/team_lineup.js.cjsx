cx = React.addons.classSet
exports = exports ? this
exports.TeamLineup = React.createClass
  displayName: 'TeamLineup'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    lineupStatusHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired
    endHandler: React.PropTypes.func.isRequired
    undoHandler: React.PropTypes.func.isRequired

  render: ()->
    <div className="jam-details">
      {this.props.teamState.jamStates.map (jamState, jamIndex) ->
        <JamDetail
          key={jamState.jamNumber}
          teamAttributes={this.props.teamState}
          jamState={jamState}
          noPivotHandler={this.props.noPivotHandler.bind(this, jamIndex)}
          starPassHandler={this.props.starPassHandler.bind(this, jamIndex)}
          lineupStatusHandler={this.props.lineupStatusHandler.bind(this, jamIndex)}
          setSelectorContextHandler={this.props.setSelectorContextHandler.bind(this, jamIndex)}
          selectSkaterHandler={this.props.selectSkaterHandler.bind(this, jamIndex)} />
      , this }
      <LineupTrackerActions endHandler={this.props.endHandler} undoHandler={this.props.undoHandler}/>
    </div>