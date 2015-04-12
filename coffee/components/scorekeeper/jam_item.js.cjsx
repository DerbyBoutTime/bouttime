cx = React.addons.classSet
exports = exports ? this
exports.JamItem = React.createClass
  displayName: 'JamItem'
  propTypes:
    jamState: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
  totalPoints: () ->
    points = 0
    @props.jamState.passStates.map (pass) =>
      points += pass.points || 0
    return points
  getNotes: () ->
    jam = @props.jamState
    flags = jam.passStates.reduce (prev, pass) ->
      injury: prev.injury or pass.injury
      nopass: prev.nopass or pass.nopass
      calloff: prev.calloff or pass.calloff
      lost: prev.lost  or pass.lostLead
      lead: prev.lead or pass.lead
    , {}
    Object.keys(flags).filter (key) ->
      flags[key]
  render: () ->
    notes = @getNotes()
    jammer = @props.jamState.jammer
    jammerNumber = if jammer? then jammer.number else <span>&nbsp;</span>
    <div className="jam-row">
      <div className="row gutters-xs" onClick={@props.selectionHandler} >
        <div className="col-sm-2 col-xs-2">
          <div className="jam boxed-good text-center">
            {@props.jamState.jamNumber}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className='boxed-good text-center'>
            <strong>{jammerNumber}</strong>
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <ScoreNote note={notes[0]}/>
        </div>
        <div className="col-sm-2 col-xs-2">
          <ScoreNote note={notes[1]}/>
        </div>
        <div className="col-sm-2 col-xs-2">
          <ScoreNote note={notes[2]}/>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="points boxed-good text-center">
            <strong>{@totalPoints()}</strong>
          </div>
        </div>
      </div>
    </div>