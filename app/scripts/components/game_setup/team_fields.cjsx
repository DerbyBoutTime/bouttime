React = require 'react/addons'
RosterFields = require './roster_fields'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamFields'
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $dom.find(".background-color.colorpicker").minicolors
      theme: 'bootstrap'
      changeDelay: 200
      change: (color) =>
        @props.actions.updateTeam @props.teamState,
          colorBarStyle:
            backgroundColor: color       
    $dom.find(".text-color.colorpicker").minicolors
      theme: 'bootstrap'
      changeDelay: 200
      change: (color) =>
        @props.actions.updateTeam @props.teamState,
          colorBarStyle:
            color: color
  handleNameChange: (evt) ->
    @props.actions.updateTeam @props.teamState, name: evt.target.value
  handleInitialsChange: (evt) ->
    @props.actions.updateTeam @props.teamState, initials: evt.target.value
  handleBackgroundColorChange: (evt) ->
    @props.actions.updateTeam @props.teamState,
      colorBarStyle:
        backgroundColor: evt.target.value
  handleTextColorChange: (evt) ->
    @props.actions.updateTeam @props.teamState,
      colorBarStyle:
        color: evt.target.value
  render: () ->
    <div className='team-fields col-xs-12 col-sm-6'>
      <h3>{@props.teamType} Team</h3>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-name">Name</label>
        <input type="text" className="form-control" id="#{@props.teamType}-team-name" value={@props.teamState.name} onChange={@handleNameChange}/>
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-initials">Initials</label>
        <input type="text" className="form-control" id="#{@props.teamType}-team-initials" value={@props.teamState.initials} onChange={@handleInitialsChange}/>
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-background-color">Background Color</label>
        <input type="text" className="form-control background-color colorpicker" id="#{@props.teamType}-team-background-color" value={@props.teamState.colorBarStyle.backgroundColor} onChange={@handleBackgroundColorChange}/>
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-text-color">Text Color</label>
        <input type="text" className="form-control text-color colorpicker" id="#{@props.teamType}-team-text-color" value={@props.teamState.colorBarStyle.color} onChange={@handleTextColorChange} />
      </div>
      <RosterFields {...@props} />
    </div>