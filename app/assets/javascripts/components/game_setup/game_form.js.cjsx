cx = React.addons.classSet
exports = exports ? this
exports.GameForm = React.createClass
  displayName: 'GameForm'
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $dom.find('.datepicker').datetimepicker
      format: 'MM/DD/YYYY'
    $dom.find('.timepicker').datetimepicker
      format: 'LT'
  render: () ->
    <form className='game-form'>
      <h2>Game Setup</h2>
      <h3>Game Details</h3>
      <div className='form-group'>
        <label htmlFor="game-name">Name</label>
        <input type="text" className="form-control" id="game-name" />
      </div>
      <div className='form-group'>
        <label htmlFor="game-venue">Venue</label>
        <input type="text" className="form-control" id="game-venue" />
      </div>
      <div className='form-group'>
        <label htmlFor="game-date">Date</label>
        <div className='input-group datepicker'>
          <input type='text' className="form-control" id='game-date' />
          <span className="input-group-addon">
            <span className="glyphicon glyphicon-calendar"></span>
          </span>
        </div>
      </div>
      <div className='form-group'>
        <label htmlFor="game-time">Time</label>
        <div className='input-group timepicker'>
          <input type='text' className="form-control" id='game-time' />
          <span className="input-group-addon">
            <span className="glyphicon glyphicon-time"></span>
          </span>
        </div>
      </div>
      <TeamFields teamType='home' />
      <TeamFields teamType='away' />
      <button type="submit" className="btn btn-primary">Create Game</button>
    </form>
