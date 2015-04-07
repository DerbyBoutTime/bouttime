cx = React.addons.classSet
exports = exports ? this
exports.RosterFields = React.createClass
  displayName: 'RosterFields'
  handleNameChange: (skaterIndex, evt) ->
    @props.actions.updateSkater skaterIndex, name: evt.target.value
  handleNumberChange: (skaterIndex, evt) ->
    @props.actions.updateSkater skaterIndex, number: evt.target.value
  getInitialState: () ->
    skaters: []
  render: () ->
    <div className='roster-fields'>
      <h3>Roster</h3>
      {@props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <div key={skaterIndex} className="skater-fields">
          <button type="button" className="close" onClick={@props.actions.removeSkater.bind(this, skaterIndex)}><span className="glyphicon glyphicon-remove"></span></button>
          <div className='form-group'>
            <label htmlFor="#{@props.teamType}-skater-name[#{skaterIndex}]">Skater Name</label>
            <input type="text" className="form-control" id="#{@props.teamType}-skater-name[#{skaterIndex}]" value={skaterState.skater.name} onChange={@handleNameChange.bind(this, skaterIndex)}/>
          </div>
          <div className='form-group'>
            <label htmlFor="#{@props.teamType}-skater-number[#{skaterIndex}]">Skater Number</label>
            <input type="text" className="form-control" id="#{@props.teamType}-skater-number[#{skaterIndex}]" value={skaterState.skater.number} onChange={@handleNumberChange.bind(this, skaterIndex)}/>
          </div>
        </div>
      , this}
      <button type="button" className="bt-btn" onClick={@props.actions.addSkater}><span className="glyphicon glyphicon-plus"></span></button>
    </div>