React = require 'react/addons'
JamDetail = require './jam_detail.cjsx'
LineupTrackerActions = require './lineup_tracker_actions.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamLineup'
  propTypes:
    team: React.PropTypes.object.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
  render: ()->
    <div className="team-lineup">
      {@props.team.jams.map (jam, jamIndex) ->
        <JamDetail
          key={jam.id}
          team={@props.team}
          jam={jam}
          setSelectorContextHandler={@props.setSelectorContextHandler.bind(this, jam)} />
      , this }
      <LineupTrackerActions {...@props} />
    </div>