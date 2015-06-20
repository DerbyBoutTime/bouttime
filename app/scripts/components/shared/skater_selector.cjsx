React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'SkaterSelector'
  propTypes:
    skater: React.PropTypes.object
    style: React.PropTypes.object
    injured: React.PropTypes.bool
    setSelectorContext: React.PropTypes.func
    selectHandler: React.PropTypes.func
    placeholder: React.PropTypes.string
    target: React.PropTypes.string
  getDefaultProps: () ->
    target: "#skater-selector-modal"
  buttonContent: () ->
    if @props.skater
      @props.skater.number
    else
      <strong>{@props.placeholder}<span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
  render: () ->
    buttonClass = cx
      'skater-selector bt-btn': true
      'injury': @props.injured
    <button
      className={buttonClass}
      data-toggle="modal"
      style={if @props.skater and not @props.injured then @props.style else {}}
      data-target={@props.target}
      onClick={@props.setSelectorContext.bind(this, @props.selectHandler)}>
      <strong>{@buttonContent()}</strong>
    </button>