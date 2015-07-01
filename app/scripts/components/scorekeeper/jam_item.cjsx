React = require 'react/addons'
ScoreNote = require './score_note.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamItem'
  propTypes:
    jam: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
  render: () ->
    notes = @props.jam.getNotes()
    jammer = @props.jam.jammer
    jammerNumber = if jammer? then jammer.number else <span>&nbsp;</span>
    <div className="jam-item" onClick={@props.selectionHandler}>
      <div className="col-xs-1">
        <div className="bt-box box-primary text-center">
          {@props.jam.jamNumber}
        </div>
      </div>
      <div className="col-xs-2">
        <div className="bt-box text-center">
          <strong>{jammerNumber}</strong>
        </div>
      </div>
      <div>
        <div className="col-xs-2">
          <ScoreNote note={notes[0]}/>
        </div>
        <div className="col-xs-2">
          <ScoreNote note={notes[1]}/>
        </div>
        <div className="col-xs-2">
          <ScoreNote note={notes[2]}/>
        </div>
        <div className="col-xs-2">
          <div className="bt-box box-default text-center">
            <strong>{@props.jam.getPoints()}</strong>
          </div>
        </div>
      </div>
    </div>
