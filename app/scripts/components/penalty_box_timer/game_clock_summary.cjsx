React = require 'react/addons'
{ClockManager} = require '../../clock'
module.exports = React.createClass
  displayName: 'GameClockSummary'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  # componentDidMount: () ->
  #   @clockManager = new ClockManager()
  #   @clockManager.addTickListener @onTick
  # componentWillUnmount: () ->
  #   @clockManager.removeTickListener @onTick
  # onTick: () ->
  #   @forceUpdate()
  render: () ->
    <div className="game-clock-summary">
      <div className="row gutters-xs hidden-xs hidden-sm">
        <div className="col-xs-6">
          <div className='row gutters-xs'>
            <div className="col-xs-6 text-capitalize">
              <strong>{@props.gameState.period}</strong>
            </div>
            <div className="col-xs-6 text-right">
              <strong>Jam {@props.gameState.jamNumber}</strong>
            </div>
          </div>
          <div className='row gutters-xs'>
            <div className='col-xs-12'>
              <div className="period-clock">{@props.gameState.periodClock.display()}</div>
            </div>
          </div>
        </div>
        <div className="col-xs-6">
          <div className='row gutters-xs'>
            <div className='col-xs-12 text-center text-capitalize'>
              <strong>{@props.gameState.state.replace(/_/g, ' ')}</strong>
            </div>
          </div>
          <div className='row gutters-xs'>
            <div className='col-xs-12'>
              <div className="jam-clock">{@props.gameState.jamClock.display()}</div>
            </div>
          </div>
        </div>
      </div>
    </div>