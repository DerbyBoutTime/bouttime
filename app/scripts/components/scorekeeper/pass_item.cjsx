React = require 'react/addons'
$ = require 'jquery'
functions = require '../../functions.coffee'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
ScoreNote = require './score_note.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PassItem'
  propTypes:
    pass: React.PropTypes.object.isRequired
    panelId: React.PropTypes.string.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  setJammer: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PASS_JAMMER
      passId: @props.pass.id
      skaterId: skaterId
  hidePanels: () ->
    $('.scorekeeper .collapse.in').collapse('hide');
  render: () ->
    injuryClass = cx
      'selected': @props.pass.injury
      'notes': true
      'injury': true
      'text-center': true
    callClass = cx
      'selected': @props.pass.calloff
      'notes': true
      'call': true
      'text-center': true
    lostClass = cx
      'selected': @props.pass.lostLead
      'notes': true
      'lost': true
      'text-center': true
    notes = @props.pass.getNotes()
    jammer = @props.pass.jammer
    <div className='pass-row'>
      <div className="col-sm-2 col-xs-2">
        <div className="pass boxed-good text-center" >
          {@props.pass.passNumber}
        </div>
      </div>
      <div className="col-sm-2 col-xs-2">
          <SkaterSelector
            skater={jammer}
            injured={@props.pass.injury}
            style={@props.style}
            setSelectorContext={@props.setSelectorContext}
            selectHandler={@setJammer} />
      </div>
      <div data-toggle="collapse" data-target={"##{@props.panelId}"} aria-expanded="false" aria-controls={@props.panelId} onClick={@hidePanels}>
        <div className="col-sm-2 col-xs-2">
          <ScoreNote note={notes[0]} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <ScoreNote note={notes[1]} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <ScoreNote note={notes[2]} />
        </div>
        <div className="col-sm-2 col-xs-2">
          <div className="points boxed-good text-center">
            <strong>{@props.pass.points ? 0}</strong>
          </div>
        </div>
      </div>
    </div>
