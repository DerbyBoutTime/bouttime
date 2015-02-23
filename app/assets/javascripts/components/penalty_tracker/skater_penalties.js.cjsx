cx = React.addons.classSet
exports = exports ? this
exports.SkaterPenalties = React.createClass
  displayName: 'SkaterPenalties'
  propTypes:
    skaterState: React.PropTypes.object
    penalties: React.PropTypes.array.isRequired
    currentJamNumber: React.PropTypes.number.isRequired
    applyHandler: React.PropTypes.func
    cancelHandler: React.PropTypes.func
    teamStyle: React.PropTypes.object
    hidden: React.PropTypes.bool

  getInitialState: () ->
    workingSkaterState: $.extend(true, {}, this.props.skaterState)
    editingPenaltyIndex: null

  resetState: (callback) ->
    this.dirty = true

  componentWillReceiveProps: (nextProps) ->
    if this.dirty
      this.dirty = false
      $('#edit-penalty-panel').collapse('hide')
      this.setState
        workingSkaterState: $.extend(true, {}, nextProps.skaterState)
        editingPenaltyIndex: null

  getEditingPenalty: () ->
    this.state.workingSkaterState.penaltyStates[this.state.editingPenaltyIndex]

  newPenaltyState: () ->
    jamNumber: this.props.currentJamNumber
    sort: this.state.editingPenaltyIndex

  editPenaltyState: (penaltyStateIndex) ->
    this.setState(editingPenaltyIndex: penaltyStateIndex)
    this.refs.editPenaltyPanel.resetState()
    $('#edit-penalty-panel').collapse('show')

  closeEdit: () ->
    this.setState(editingPenaltyIndex: null)
    $('#edit-penalty-panel').collapse('hide')

  toggleEdit: (penaltyStateIndex) ->
    if this.state.editingPenaltyIndex? then this.closeEdit() else this.editPenaltyState(penaltyStateIndex)

  setJamNumber: (jamNumber) ->
    editingPenalty = this.getEditingPenalty() || this.newPenaltyState()
    editingPenalty.jamNumber = jamNumber
    this.state.workingSkaterState.penaltyStates[this.state.editingPenaltyIndex] = editingPenalty
    this.setState(this.state)
    this.closeEdit()

  setPenalty: (penaltyIndex) ->
    return if !this.state.editingPenaltyIndex?

    editingPenaltyState = this.getEditingPenalty() || this.newPenaltyState()
    selectedPenalty = this.props.penalties[penaltyIndex]

    if editingPenaltyState.penalty? and editingPenaltyState.penalty.name is selectedPenalty.name
      delete this.state.workingSkaterState.penaltyStates[this.state.editingPenaltyIndex]
    else
      editingPenaltyState.penalty = selectedPenalty
      this.state.workingSkaterState.penaltyStates[this.state.editingPenaltyIndex] = editingPenaltyState
    this.setState(this.state)

  render: () ->
    containerClass = cx
      'skater-penalties': true
      'hidden': this.props.hidden
    if this.props.skaterState?
      <div className={containerClass}>
        <div className='row gutters-xs top-buffer actions' >
          <div className='col-sm-6 col-xs-6'>
            <button className='btn btn-block btn-boxed action apply' onClick={this.props.applyHandler.bind(null, this.state.workingSkaterState)} >
              <span className='icon glyphicon glyphicon-ok'></span><strong>Apply</strong>
            </button>
          </div>
          <div className='col-sm-6 col-xs-6'>
            <button className='btn btn-block btn-boxed action cancel' onClick={this.props.cancelHandler}>
              <span className='icon glyphicon glyphicon-remove'></span><strong>Cancel</strong>
            </button>
          </div>
        </div>
        <div className='row gutters-xs top-buffer'>
          <div className='col-sm-2 col-xs-2'>
            <div className='btn btn-block btn-boxed' style={this.props.teamStyle}>
              <strong>{this.props.skaterState.skater.number}</strong>
            </div>
          </div>
        </div>
        <div className='row gutters-xs top-buffer penalty-controls'>
          <div className='col-xs-10 col-sm-10'>
            <div className='row gutters-xs'>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={1}
                  penaltyState={this.state.workingSkaterState.penaltyStates[0]}
                  clickHandler={this.toggleEdit.bind(this, 0)}
                  teamStyle={this.props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={2}
                  penaltyState={this.state.workingSkaterState.penaltyStates[1]}
                  clickHandler={this.toggleEdit.bind(this, 1)}
                  teamStyle={this.props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={3}
                  penaltyState={this.state.workingSkaterState.penaltyStates[2]}
                  clickHandler={this.toggleEdit.bind(this, 2)}
                  teamStyle={this.props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={4}
                  penaltyState={this.state.workingSkaterState.penaltyStates[3]}
                  clickHandler={this.toggleEdit.bind(this, 3)}
                  teamStyle={this.props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={5}
                  penaltyState={this.state.workingSkaterState.penaltyStates[4]}
                  clickHandler={this.toggleEdit.bind(this, 4)}
                  teamStyle={this.props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={6}
                  penaltyState={this.state.workingSkaterState.penaltyStates[5]}
                  clickHandler={this.toggleEdit.bind(this, 5)}
                  teamStyle={this.props.teamStyle} />
              </div>
            </div>
          </div>
          <div className='col-xs-2 col-sm-2'>
            <div className='penalty-7'>
              <PenaltyControl
                penaltyNumber={7}
                penaltyState={this.state.workingSkaterState.penaltyStates[6]}
                clickHandler={this.toggleEdit.bind(this, 6)}
                teamStyle={this.props.teamStyle} />
            </div>
          </div>
        </div>
        <EditPenaltyPanel ref='editPenaltyPanel'
          penalty={this.getEditingPenalty() || this.newPenaltyState()}
          applyHandler={this.setJamNumber}
          cancelHandler={this.closeEdit}/>
        <div className='penalties-list'>
          {this.props.penalties[0...-1].map((penalty, penaltyIndex) ->
            <div key={penaltyIndex} className='penalty'>
              <div className='col-xs-1 col-sm-1'>
                <button className='penalty-code btn btn-block btn-boxed' onClick={this.setPenalty.bind(this, penaltyIndex)}>
                  <strong>{penalty.code}</strong>
                </button>
              </div>
              <div className='col-xs-5 col-sm-5'>
                <button className='penalty-name btn btn-block btn-boxed' onClick={this.setPenalty.bind(this, penaltyIndex)}>
                  <strong>{penalty.name}</strong>
                </button>
              </div>
            </div>
          , this).map((elem, i, elems) ->
            if i % 2 then null else <div key={i} className='row gutters-xs top-buffer'>{elems[i..i+1]}</div>
          ).filter (elem) ->
            elem?
          }
          <div className='row gutters-xs top-buffer'>
            <div className='col-xs-1 col-sm-1'>
              <button className='penalty-code btn btn-block btn-boxed' onClick={this.setPenalty.bind(this, this.props.penalties.length - 1)}>
                <strong>{this.props.penalties[this.props.penalties.length - 1].code}</strong>
              </button>
            </div>
            <div className='col-xs-11 col-sm-11'>
              <button className='penalty-name btn btn-block btn-boxed' onClick={this.setPenalty.bind(this, this.props.penalties.length - 1)}>
                <strong>{this.props.penalties[this.props.penalties.length - 1].name} - Expulsion</strong>
              </button>
            </div>
          </div>
        </div>
      </div>
    else
      <div className={containerClass}></div>