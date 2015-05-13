React = require 'react/addons'
module.exports = React.createClass
  displayName: 'TimeoutBars'
  shouldComponentUpdate: (nprops, nstate) ->
    _.isEqual(@props, nprops) == false
  render: () ->
    <div className="timeout-bars #{@props.homeOrAway}">
      <span className="jt-label">{@props.initials}</span>
      <div className={@props.classSets[0]} onClick={@props.handleToggleTimeoutBar}>{@props.reviewsRetained}</div>
      <div className={@props.classSets[1]} onClick={@props.handleToggleTimeoutBar}></div>
      <div className={@props.classSets[2]} onClick={@props.handleToggleTimeoutBar}></div>
      <div className={@props.classSets[3]} onClick={@props.handleToggleTimeoutBar}></div>
    </div>