React = require 'react/addons'
{ClockManager} = require '../../clock'
module.exports = React.createClass
  displayName: 'JamSummary'
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
        <div className="col-xs-12 text-center text-capitalize">
          <strong className='jt-label'>{@props.state.replace(/_/g, ' ')}</strong>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className="col-xs-12">
          <div className="bt-box box-lg text-center box-default" onClick={@props.clickClock}>
            {@props.clock.display()}
          </div>
        </div>
      </div>
    </div>