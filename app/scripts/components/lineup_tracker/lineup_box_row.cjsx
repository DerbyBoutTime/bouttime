React = require 'react/addons'
LineupBox = require './lineup_box.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupBoxRow'
  propTypes:
    lineupStatus: React.PropTypes.object
    cycleLineupStatus: React.PropTypes.func
    positions: React.PropTypes.array
  getDefaultProps: () ->
    lineupStatus:
      pivot: 'clear'
      blocker1: 'clear'
      blocker2: 'clear'
      blocker3: 'clear'
      jammer: 'clear'
  render: () ->
    <div className="row gutters-xs top-buffer">
      {@props.positions.map (pos) ->
        <div className="col-xs-5-cols">
          <LineupBox status={@props.lineupStatus[pos]} cycleLineupStatus={@props.cycleLineupStatus.bind(null, pos)} />
        </div>
      , this}
    </div>