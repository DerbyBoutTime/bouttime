React = require 'react/addons'
module.exports = React.createClass
  displayName: 'ScoreboardClocks'
  getInitialState: () ->
    periodClock: @props.periodClock
    jamClock: @props.jamClock
  render: () ->
    <div>
      <div className="period-clock">
        <label className="visible-xs-block">Game</label>
        <div className="clock period-clock">{@state.periodClock}</div>
      </div>
      <div className="jam-clock">
        <label className="jam-clock-label">{@props.jamLabel}</label>
        <div className="clock">{@state.jamClock}</div>
      </div>
    </div>