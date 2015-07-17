React = require 'react/addons'
{ClockManager} = require '../../clock'
module.exports = React.createClass
  displayName: 'ScoreboardClocks'
  componentDidMount: () ->
    @clockManager = new ClockManager()
    @clockManager.addTickListener @onTick
  componentWillUnmount: () ->
    @clockManager.removeTickListener @onTick
  onTick: () ->
    @forceUpdate()
  render: () ->
    periodNumber = switch @props.gameState.period
      when 'period 1' then '1'
      when 'period 2' then '2'
      when 'pregame' then 'Pre'
      when 'halftime' then 'Half'
      when 'unofficial final' then 'UF'
      when 'official final' then 'OF'
      else ''
    jamLabel = @props.gameState.state.replace /_/g, ' '
    <div className="clocks">
      <div className="row gutters-xs">
        <div className="col-xs-6">
          <label className="hidden-xs">Period</label>
          <label className="visible-xs-inline-block">Per</label>
          <div className="period-number">{periodNumber}</div>
        </div>
        <div className="col-xs-6">
          <label>Jam</label>
          <div className="jam-number">{@props.gameState.jamNumber}</div>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className="col-xs-6 col-sm-12">
          <label className="visible-xs-block">Game</label>
          <div className="period-clock">{@props.gameState.periodClock.display()}</div>
        </div>
        <div className="col-xs-6 col-sm-12">
          <label>{jamLabel}</label>
          <div className="jam-clock">{@props.gameState.jamClock.display()}</div>
        </div>
      </div>
    </div>
