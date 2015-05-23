React = require 'react/addons'
{ClockManager} = require '../../clock'
module.exports = React.createClass
  displayName: 'ScoreboardClocks'
  getInitialState: () ->
    periodClock: @props.periodClock
    jamClock: @props.jamClock
  componentDidMount: () ->
    @clockManager = new ClockManager()
    @clockManager.addTickListener @onTick
  onTick: () ->
    @forceUpdate()
  render: () ->
    <div>
      <div className="period-clock">
        <label className="visible-xs-block">Game</label>
        <div className="clock period-clock">{@props.periodClock.display()}</div>
      </div>
      <div className="jam-clock">
        <label className="jam-clock-label">{@props.jamLabel}</label>
        <div className="clock">{@props.jamClock.display()}</div>
      </div>
    </div>