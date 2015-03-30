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
      {@props.teamState.jamStates.map (jamState, jamIndex) ->
        <JamDetail
          key={jamState.jamNumber}
          teamAttributes={@props.teamState}
          jamState={jamState}
          noPivotHandler={@props.noPivotHandler.bind(this, jamIndex)}
          starPassHandler={@props.starPassHandler.bind(this, jamIndex)}
          lineupStatusHandler={@props.lineupStatusHandler.bind(this, jamIndex)}
          setSelectorContextHandler={@props.setSelectorContextHandler.bind(this, jamIndex)}
          selectSkaterHandler={@props.selectSkaterHandler.bind(this, jamIndex)} />
      , this }
      <LineupTrackerActions endHandler={@props.endHandler} undoHandler={@props.undoHandler}/>
    </div>