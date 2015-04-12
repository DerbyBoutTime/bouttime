cx = React.addons.classSet
exports = exports ? this
exports.PassItem = React.createClass
  displayName: 'PassItem'
  propTypes:
    jamState: React.PropTypes.object.isRequired
    passState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
  isInjured: (position) ->
    @props.jamState.lineupStatuses? and @props.jamState.lineupStatuses.some (status) ->
      status[position] is 'injured'
  hidePanels: () ->
    $('.scorekeeper .collapse.in').collapse('hide');
  getNotes: () ->
    pass = @props.passState
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
      'selected': @props.passState.injury
      'notes': true
      'injury': true
      'text-center': true
    callClass = cx
      'selected': @props.passState.calloff
      'notes': true
      'call': true
      'text-center': true
    lostClass = cx
      'selected': @props.passState.lostLead
      'notes': true
      'lost': true
      'text-center': true
    editPassId = "edit-pass-#{exports.wftda.functions.uniqueId()}"
    notes = @getNotes()
    skater = if @props.passState.skaterNumber? then {number: @props.passState.skaterNumber} else null
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
                {@props.passState.passNumber}
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <SkaterSelector
                skater={skater}
                injured={@isInjured('jammer')}
                style={@props.style}
                setSelectorContext={@props.setSelectorContext}
                selectHandler={@props.actions.setSkater} />
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
                  <strong>{@props.passState.points || 0}</strong>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <PassEditPanel {...@props} editPassId={editPassId}/>
    </div>