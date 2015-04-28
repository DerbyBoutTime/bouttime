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
  buttonContent: () ->
    if @props.skater
      @props.skater.number
    else
      <strong>{@props.placeholder}<span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
  render: () ->
    injuryClass = cx
      'skater-injury': @props.injured
    <button
      className={injuryClass + " skater-selector text-center bt-btn"}
      data-toggle="modal"
      style={if @props.skater and not @props.injured then @props.style else {}}
      data-target="#skater-selector-modal"
      onClick={@props.setSelectorContext.bind(this, @props.selectHandler)}>
      <strong>{@buttonContent()}</strong>
    </button>