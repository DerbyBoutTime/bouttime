React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'RosterFields'
  handleNameChange: (skater, evt) ->
    @props.actions.updateSkater skater, name: evt.target.value
  handleNumberChange: (skater, evt) ->
    @props.actions.updateSkater skater, number: evt.target.value
  getInitialState: () ->
    skaters: []
  render: () ->
    <div className='roster-fields'>
      <h3>Roster</h3>
      {@props.teamState.skaters.map (skater, skaterIndex) ->
        <div key={skater.id} className="skater-fields">
          <div className='row'>
            <button type="button" className="close" onClick={@props.actions.removeSkater.bind(null, @props.teamState, skater)}><span className="glyphicon glyphicon-remove"></span></button>
          </div>
          <div className='row'>
            <div className='col-xs-6'>
              <div className='form-group'>
                <label htmlFor="#{@props.teamType}-skater-name[#{skaterIndex}]">Skater Name</label>
                <input type="text" className="form-control" id="#{@props.teamType}-skater-name[#{skaterIndex}]" value={skater.name} onChange={@handleNameChange.bind(this, skater)}/>
              </div>
            </div>
            <div className='col-xs-6'>
              <div className='form-group'>
                <label htmlFor="#{@props.teamType}-skater-number[#{skaterIndex}]">Skater Number</label>
                <input type="text" className="form-control" id="#{@props.teamType}-skater-number[#{skaterIndex}]" value={skater.number} onChange={@handleNumberChange.bind(this, skater)}/>
              </div>
            </div>
          </div>
        </div>
      , this}
      <button type="button" className="bt-btn" onClick={@props.actions.addSkater.bind(null, @props.teamState)}><span className="glyphicon glyphicon-plus"></span></button>
    </div>