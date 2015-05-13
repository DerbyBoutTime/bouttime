React = require 'react/addons'
TeamFields = require './team_fields'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'GameForm'
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $dom.find('.datepicker').datetimepicker
      format: 'MM/DD/YYYY'
    .on 'dp.change', (evt) =>
      @props.actions.updateGame date: moment(evt.date).format('MM/DD/YYYY')
    $dom.find('.timepicker').datetimepicker
      format: 'LT'
    .on 'dp.change', (evt) =>
      @props.actions.updateGame time: moment(evt.date).format('LT')
  handleNameChange: (evt) ->
    @props.actions.updateGame name: evt.target.value
  handleVenueChange: (evt) ->
    @props.actions.updateGame venue: evt.target.value
  handleDateChange: (evt) ->
    @props.actions.updateGame date: evt.target.value
  handleTimeChange: (evt) ->
    @props.actions.updateGame time: evt.target.value
  handleOfficialChange: (idx, evt) ->
    @props.actions.updateOfficial idx, evt.target.value
  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.actions.saveGame()
  render: () ->
    <form className='game-form' onSubmit={@handleSubmit}>
      <hr />
      <h2>Game Setup</h2>
      <div className='form-group'>
        <label htmlFor="game-name">Name</label>
        <input type="text" className="form-control" id="game-name" value={@props.gameState.name} onChange={@handleNameChange} />
      </div>
      <div className='form-group'>
        <label htmlFor="game-venue">Venue</label>
        <input type="text" className="form-control" id="game-venue" value={@props.gameState.venue} onChange={@handleVenueChange}/>
      </div>
      <div className='form-group'>
        <label htmlFor="game-date">Date</label>
        <div className='input-group datepicker'>
          <input type='text' className="form-control" id='game-date' value={@props.gameState.date} onChange={@handleDateChange}/>
          <span className="input-group-addon">
            <span className="glyphicon glyphicon-calendar"></span>
          </span>
        </div>
      </div>
      <div className='form-group'>
        <label htmlFor="game-time">Time</label>
        <div className='input-group timepicker'>
          <input type='text' className="form-control" id='game-time' value={@props.gameState.time} onChange={@handleTimeChange}/>
          <span className="input-group-addon">
            <span className="glyphicon glyphicon-time"></span>
          </span>
        </div>
      </div>
      <h3>Officials</h3>
      {@props.gameState.officials.map (official, idx) ->
        <div key={idx}>
          <button type="button" className="close" onClick={@props.actions.removeOfficial.bind(null, @props.gameState, idx)}><span className="glyphicon glyphicon-remove"></span></button>
          <div className='form-group'>
            <label htmlFor="official[#{idx}]">Name</label>
            <input type="text" className="form-control" id="official[#{idx}]" value={official} onChange={@handleOfficialChange.bind(this, idx)}/>
          </div>
        </div>
      , this}
      <button type="button" className="bt-btn" onClick={@props.actions.addOfficial.bind(null, @props.gameState)}><span className="glyphicon glyphicon-plus"></span></button>
      <div className='row'>
        <TeamFields teamType='home' teamState={@props.gameState.home} actions={@props.actions}/>
        <TeamFields teamType='away' teamState={@props.gameState.away} actions={@props.actions}/>
      </div>
      <button type="submit" className="btn btn-primary margin-xs">Save Game</button>
    </form>
