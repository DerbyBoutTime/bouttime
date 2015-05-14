React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
ScoreNote = require './score_note.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamItem'
  propTypes:
    jam: React.PropTypes.object.isRequired
    selectionHandler: React.PropTypes.func
  setJammer: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_SKATER_POSITION
      jamId: @props.jam.id
      position: 'jammer'
      skaterId: skaterId
  render: () ->
    notes = @props.jam.getNotes()
    jammer = @props.jam.jammer
    jammerNumber = if jammer? then jammer.number else <span>&nbsp;</span>
    <div className="jam-row">
      <div className="row gutters-xs">
        <div className="col-sm-2 col-xs-2" onClick={@props.selectionHandler}>
          <div className="jam boxed-good text-center">
            {@props.jam.jamNumber}
          </div>
        </div>
        <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={@props.jam.jammer}
            injured={@props.jam.isInjured('jammer')}
            style={@props.style}
            setSelectorContext={@props.setSelectorContext}
            selectHandler={@setJammer} />
        </div>
        <div onClick={@props.selectionHandler}>
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
              <strong>{@props.jam.getPoints()}</strong>
            </div>
          </div>
        </div>
      </div>
    </div>
