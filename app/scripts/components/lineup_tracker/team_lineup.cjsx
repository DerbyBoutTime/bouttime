React = require 'react/addons'
JamDetail = require './jam_detail.cjsx'
LineupTrackerActions = require './lineup_tracker_actions.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamLineup'
  propTypes:
    team: React.PropTypes.object.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    lineupStatusHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired
    endHandler: React.PropTypes.func.isRequired
  render: ()->
    <div className="jam-details">
      {@props.team.jams.map (jam, jamIndex) ->
        <JamDetail
          key={jam.jamNumber}
          team={@props.team}
          jam={jam}
          noPivotHandler={@props.noPivotHandler.bind(this, jamIndex)}
          starPassHandler={@props.starPassHandler.bind(this, jamIndex)}
          lineupStatusHandler={@props.lineupStatusHandler.bind(this, jamIndex)}
          setSelectorContextHandler={@props.setSelectorContextHandler.bind(this, jamIndex)}
          selectSkaterHandler={@props.selectSkaterHandler.bind(this, jamIndex)} />
      , this }
      <LineupTrackerActions endHandler={@props.endHandler}/>
    </div>