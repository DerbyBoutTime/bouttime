cx = React.addons.classSet
exports = exports ? this
exports.TeamFields = React.createClass
  displayName: 'TeamFields'
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $dom.find(".colorpicker").minicolors theme: 'bootstrap'
  render: () ->
    <div className='team-fields'>
      <h3>{@props.teamType} Team</h3>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-name">Name</label>
        <input type="text" className="form-control" id="#{@props.teamType}-team-name" />
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-initials">Initials</label>
        <input type="text" className="form-control" id="#{@props.teamType}-team-initials" />
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-background-color">Background Color</label>
        <input type="text" className="form-control colorpicker" id="#{@props.teamType}-team-background-color" />
      </div>
      <div className='form-group'>
        <label htmlFor="#{@props.teamType}-team-text-color">Text Color</label>
        <input type="text" className="form-control colorpicker" id="#{@props.teamType}-team-text-color" />
      </div>
    </div>