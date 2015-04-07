cx = React.addons.classSet
exports = exports ? this
exports.TeamFields = React.createClass
  displayName: 'TeamFields'
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $dom.find(".colorpicker").minicolors theme: 'bootstrap'
  handleNameChange: (evt) ->
    @props.actions.updateTeam name: evt.target.value
  handleInitialsChange: (evt) ->
    @props.actions.updateTeam initials: evt.target.value
  handleBackgroundColorChange: (evt) ->
    @props.actions.updateTeam color: evt.target.value
  handleTextColorChange: (evt) ->
    @props.actions.updateTeaam textColor: evt.target.value
  render: () ->
    <div className='team-fields'>
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
        <input type="text" className="form-control colorpicker" id="#{@props.teamType}-team-background-color" value={@props.teamState.color} onChange={@handleBackgroundColorChange}/>
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-text-color">Text Color</label>
        <input type="text" className="form-control colorpicker" id="#{@props.teamType}-team-text-color" value={@props.teamState.textColor} onChange={@handleTextColorChange} />
      </div>
      <RosterFields {...@props} />
    </div>