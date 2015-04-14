React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
functions = require '../../functions.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
ScoreNote = require './score_note.cjsx'
PassEditPanel = require './pass_edit_panel.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PassItem'
  propTypes:
    jam: React.PropTypes.object.isRequired
    pass: React.PropTypes.object.isRequired
  setSkater: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PASS_JAMMER
      passId: @props.pass.id
      skaterId: skaterId
  isInjured: (position) ->
    @props.jam.lineupStatuses? and @props.jam.lineupStatuses.some (status) ->
      status[position] is 'injured'
  hidePanels: () ->
    $('.scorekeeper .collapse.in').collapse('hide');
  getNotes: () ->
    pass = @props.pass
    flags =
      injury: pass.injury
      nopass: pass.nopass
      calloff: pass.calloff
      lost: pass.lostLead
      lead: pass.lead
    Object.keys(flags).filter (key) ->
      flags[key]
  preventDefault: (evt) ->
    evt.preventDefault()
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
    editPassId = "edit-pass-#{functions.uniqueId()}"
    notes = @getNotes()
    <div aria-multiselectable="true" draggable='true' onDragStart={@props.dragHandler} onDragOver={@preventDefault} onDrop={@props.dropHandler} onMouseDown={@props.mouseDownHandler}>
      <div className="columns">
        <div className="row gutters-xs">
          <div className="col-sm-1 col-xs-1">
            <div className="drag-handle">
              <span className="glyphicon glyphicon-th-list" />
            </div>
          </div>
          <div className="col-sm-11 col-xs-11">
            <div className="col-sm-2 col-xs-2">
              <div className="pass boxed-good text-center" >
                {@props.pass.passNumber}
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <SkaterSelector
                skater={@props.pass.jammer}
                injured={@isInjured('jammer')}
                style={@props.style}
                setSelectorContext={@props.setSelectorContext}
                selectHandler={@setSkater} />
              </div>
            <div data-toggle="collapse" data-target={"##{editPassId}"} aria-expanded="false" aria-controls={editPassId} onClick={@hidePanels}>
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
                  <strong>{@props.pass.points || 0}</strong>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <PassEditPanel {...@props} editPassId={editPassId}/>
    </div>
