React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'GameClockSummary'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    <div className="game-clock-summary">
      <div className="row gutters-xs hidden-xs hidden-sm">
        <div className="col-xs-6">
          <strong className="clearfix">
            <span className="pull-left">
              Period {@props.gameState.periodNumber}
            </span>
            <span className="pull-right">
              Jam {@props.gameState.jamNumber}
            </span>
          </strong>
          <div className="period-clock">{@props.gameState.periodClock.display}</div>
        </div>
        <div className="col-xs-6">
          <strong className="jt-label">{@props.gameState.state.replace(/_/g, ' ')}</strong>
          <div className="jam-clock">{@props.gameState.jamClock.display}</div>
        </div>
      </div>
    </div>