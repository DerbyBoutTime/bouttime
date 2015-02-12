cx = React.addons.classSet
exports = exports ? this
exports.JamItem = React.createClass
  displayName: 'JamItem'
  propTypes:
    jamState: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func

  totalPoints: () ->
    points = 0
    this.props.jamState.passStates.map (pass) =>
      points += pass.points || 0
    return points

  getNotes: () ->
    jam = this.props.jamState
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
    notes = this.getNotes()
    <div className="jam-row">
      <div className="row gutters-xs" onClick={this.props.selectionHandler} >
        <div className="col-sm-2 col-xs-2">
          <div className="jam boxed-good text-center">
            {this.props.jamState.jamNumber}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="skater boxed-good">
            Skater
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
            <strong>{this.totalPoints()}</strong>
          </div>
        </div>
      </div>
    </div>
