cx = React.addons.classSet
exports = exports ? this
exports.RosterFields = React.createClass
  displayName: 'RosterFields'
  addSkater: () ->
    @state.skaters.push {name: '', number: ''}
    @setState(@state)
  removeSkater: (skaterIndex) ->
    @state.skaters.splice(skaterIndex, 1)
    @setState(@state)
  handleNameChange: (skaterIndex, evt) ->
    skater = @state.skaters[skaterIndex]
    skater.name = evt.target.value
    @setState(@state)
  handleNumberChange: (skaterIndex, evt) ->
    skater = @state.skaters[skaterIndex]
    skater.number = evt.target.value
    @setState(@state)
  getInitialState: () ->
    skaters: []
  render: () ->
    <div className='roster-fields'>
      <h3>Roster</h3>
      {@state.skaters.map (skater, skaterIndex) ->
        <div key={skaterIndex} className="skater-fields">
          <button type="button" className="close" onClick={@removeSkater.bind(this, skaterIndex)}><span className="glyphicon glyphicon-remove"></span></button>
          <div className='form-group'>
            <label htmlFor="#{@props.teamType}-skater-name[#{skaterIndex}]">Skater Name</label>
            <input type="text" className="form-control" id="#{@props.teamType}-skater-name[#{skaterIndex}]" value={@state.skaters[skaterIndex].name} onChange={@handleNameChange.bind(this, skaterIndex)}/>
          </div>
          <div className='form-group'>
            <label htmlFor="#{@props.teamType}-skater-number[#{skaterIndex}]">Skater Number</label>
            <input type="text" className="form-control" id="#{@props.teamType}-skater-number[#{skaterIndex}]" value={@state.skaters[skaterIndex].number} onChange={@handleNumberChange.bind(this, skaterIndex)}/>
          </div>
        </div>
      , this}
      <button type="button" className="bt-btn" onClick={@addSkater}><span className="glyphicon glyphicon-plus"></span></button>
    </div>