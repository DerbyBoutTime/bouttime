React = require 'react/addons'
{ClockManager} = require '../../clock'
module.exports = React.createClass
  displayName: 'JTClocks'
  componentDidMount: () ->
    @clockManager = new ClockManager()
    @clockManager.addTickListener @onTick
  componentWillUnmount: () ->
    @clockManager.removeTickListener @onTick
  onTick: () ->
    @forceUpdate()
  render: () ->
    <div className="row">
      <div className="col-md-12 col-xs-12">
        <div className="period-clock" onClick={@props.periodClockClickHandler}>{@props.periodClock.display()}</div>
      </div>
      <div className="col-md-12 col-xs-12">
        <strong className="jt-label">{@props.jamLabel}</strong>
        <div className="jam-clock" onClick={@props.jamClockClickHandler}>{@props.jamClock.display()}</div>
      </div>
    </div>