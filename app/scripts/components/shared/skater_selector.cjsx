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
    style = @props.style if @props.skater and not @props.injured and not @props.skater.fouledOut() and not @props.skater.expelled()
    buttonClass = cx
      'bt-btn': true
      'btn-selector': not @props.skater?.fouledOut() and not @props.skater?.expelled() and not @props.injured
      'btn-danger': @props.skater?.fouledOut() or @props.skater?.expelled()
      'btn-injury': @props.injured
      'selected': @props.skater?
    <button
      className={buttonClass}
      data-toggle="modal"
      style={style}
      data-target={@props.target}
      onClick={@props.setSelectorContext.bind(this, @props.selectHandler)}>
      <strong>{@buttonContent()}</strong>
    </button>