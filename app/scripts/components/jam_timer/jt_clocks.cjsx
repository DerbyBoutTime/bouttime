React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
module.exports = React.createClass
  displayName: 'JTClocks'
  mixins: [PureRenderMixin]
  getInitialState: () ->
    periodClock: @props.periodClock
    jamClock: @props.jamClock
  render: () ->
    <div className="row">
      <div className="col-md-12 col-xs-12">
        <div className="period-clock" onClick={@props.periodClockClickHandler}>{@state.periodClock}</div>
      </div>
      <div className="col-md-12 col-xs-12">
        <strong className="jt-label">{@props.jamLabel}</strong>
        <div className="jam-clock" onClick={@props.jamClockClickHandler}>{@state.jamClock}</div>
      </div>
    </div>