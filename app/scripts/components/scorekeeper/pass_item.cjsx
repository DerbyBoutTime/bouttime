React = require 'react/addons'
functions = require '../../functions.coffee'
ScoreNote = require './score_note.cjsx'
PassEditPanel = require './pass_edit_panel.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PassItem'
  propTypes:
    pass: React.PropTypes.object.isRequired
  hidePanels: () ->
    $('.scorekeeper .collapse.in').collapse('hide');
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
    notes = @props.pass.getNotes()
    jammer = if @props.jam.starPass and @props.pass.passNumber > @props.jam.starPassNumber then @props.jam.pivot else @props.jam.jammer
    jammerNumber = if jammer? then jammer.number else <span>&nbsp;</span>
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
              <div className='boxed-good text-center'>
                <strong>{jammerNumber}</strong>
              </div>
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
                  <strong>{@props.pass.points ? 0}</strong>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <PassEditPanel {...@props} editPassId={editPassId}/>
    </div>
