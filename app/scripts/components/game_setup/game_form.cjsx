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
  handleSubmit: (evt) ->
    evt.preventDefault()
    @props.actions.saveGame()
  render: () ->
    <form className='game-form' onSubmit={@handleSubmit}>
      <h2>Game Setup</h2>
      <h3>Game Details</h3>
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
      <TeamFields teamType='home' teamState={@props.gameState.home} actions={@props.actions}/>
      <TeamFields teamType='away' teamState={@props.gameState.away} actions={@props.actions}/>
      <button type="submit" className="btn btn-primary">Save Game</button>
    </form>
