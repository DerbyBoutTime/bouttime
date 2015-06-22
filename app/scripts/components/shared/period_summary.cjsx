React = require 'react/addons'
{ClockManager} = require '../../clock'
module.exports = React.createClass
  displayName: 'PeriodSummary'
  shouldComponentUpdate: (nprops, nstate) ->
    _.isEqual(@props, nprops) == false
  componentDidMount: () ->
    @clockManager = new ClockManager()
    @clockManager.addTickListener @onTick
  componentWillUnmount: () ->
    @clockManager.removeTickListener @onTick
  onTick: () ->
    @forceUpdate()
  render: () ->
    <div className="period-summary clock-summary">
      <div className="row gutters-xs">
        <div className="col-xs-6 text-capitalize">
          <strong className='jt-label' onClick={@props.clickPeriod}>{@props.period}</strong>
        </div>
        <div className="col-xs-6 text-right">
          <strong className='jt-label' onClick={@props.clickJam}>Jam {@props.jamNumber}</strong>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className="col-xs-12">
          <div className="bt-box box-lg box-clock text-center" onClick={@props.clickClock}>
            {@props.clock.display()}
          </div>
        </div>
      </div>
    </div>