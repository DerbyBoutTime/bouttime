cx = React.addons.classSet
exports = exports ? this
exports.PassItem = React.createClass
  displayName: 'PassItem'
  propTypes:
    jamState: React.PropTypes.object.isRequired
    passState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
  isInjured: (position) ->
    this.props.jamState.lineupStatuses? and this.props.jamState.lineupStatuses.some (status) ->
      status[position] is 'injured'
  hidePanels: () ->
    $('.scorekeeper .collapse.in').collapse('hide');
  getNotes: () ->
    pass = this.props.passState
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
      'selected': this.props.passState.injury
      'notes': true
      'injury': true
      'text-center': true
    callClass = cx
      'selected': this.props.passState.calloff
      'notes': true
      'call': true
      'text-center': true
    lostClass = cx
      'selected': this.props.passState.lostLead
      'notes': true
      'lost': true
      'text-center': true
    editPassId = "edit-pass-#{exports.wftda.functions.uniqueId()}"
    notes = this.getNotes()
    skater = if this.props.passState.skaterNumber? then {number: this.props.passState.skaterNumber} else null
    <div aria-multiselectable="true" draggable='true' onDragStart={this.props.dragHandler} onDragOver={this.preventDefault} onDrop={this.props.dropHandler} onMouseDown={this.props.mouseDownHandler}>
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
                {this.props.passState.passNumber}
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <SkaterSelector
                skater={skater}
                injured={this.isInjured('jammer')}
                style={this.props.style}
                setSelectorContext={this.props.setSelectorContext}
                selectHandler={this.props.actions.setSkater} />
              </div>
            <div data-toggle="collapse" data-target={"##{editPassId}"} aria-expanded="false" aria-controls={editPassId} onClick={this.hidePanels}>
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
                  <strong>{this.props.passState.points || 0}</strong>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <PassEditPanel {...this.props} editPassId={editPassId}/>
    </div>
