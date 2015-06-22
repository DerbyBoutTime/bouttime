React = require 'react/addons'
LineupBox = require './lineup_box.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupBoxRow'
  propTypes:
    lineupStatus: React.PropTypes.object
    cycleLineupStatus: React.PropTypes.func
  getDefaultProps: () ->
    lineupStatus:
      pivot: 'clear'
      blocker1: 'clear'
      blocker2: 'clear'
      blocker3: 'clear'
      jammer: 'clear'
  render: () ->
    <div className="row gutters-xs top-buffer">
      <div className="col-xs-5-cols">
        <LineupBox status={@props.lineupStatus.jammer} cycleLineupStatus={@props.cycleLineupStatus.bind(null, 'jammer')} />
      </div>
      <div className="col-xs-5-cols">
        <LineupBox status={@props.lineupStatus.pivot} cycleLineupStatus={@props.cycleLineupStatus.bind(null, 'pivot')} />
      </div>
      <div className="col-xs-5-cols">
        <LineupBox status={@props.lineupStatus.blocker1} cycleLineupStatus={@props.cycleLineupStatus.bind(null, 'blocker1')} />
      </div>
      <div className="col-xs-5-cols">
        <LineupBox status={@props.lineupStatus.blocker2} cycleLineupStatus={@props.cycleLineupStatus.bind(null, 'blocker2')} />
      </div>
      <div className="col-xs-5-cols">
        <LineupBox status={@props.lineupStatus.blocker3} cycleLineupStatus={@props.cycleLineupStatus.bind(null, 'blocker3')} />
      </div>
    </div>