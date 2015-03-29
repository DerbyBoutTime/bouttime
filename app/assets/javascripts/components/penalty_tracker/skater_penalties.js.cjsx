cx = React.addons.classSet
exports = exports ? this
exports.SkaterPenalties = React.createClass
  displayName: 'SkaterPenalties'
  propTypes:
    skaterState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
    teamStyle: React.PropTypes.object
    hidden: React.PropTypes.bool
    backHandler: React.PropTypes.func.isRequired
  getInitialState: () ->
    editingPenaltyNumber: null
  findPenalty: (penaltyNumber) ->
    matches = (penalty for penalty in this.props.skaterState.penaltyStates when penalty.sort is penaltyNumber)
    matches[0]
  getEditingPenalty: () ->
    this.findPenalty(this.state.editingPenaltyNumber)
  newPenaltyState: () ->
    jamNumber: this.props.currentJamNumber
    sort: this.state.editingPenaltyNumber
  editPenaltyState: (penaltyNumber) ->
    this.setState(editingPenaltyNumber: penaltyNumber)
    this.refs.editPenaltyPanel.resetState()
    $('#edit-penalty-panel').collapse('show')
  closeEdit: () ->
    this.setState(editingPenaltyNumber: null)
    $('#edit-penalty-panel').collapse('hide')
  toggleEdit: (penaltyNumber) ->
    if this.state.editingPenaltyNumber? then this.closeEdit() else this.editPenaltyState(penaltyNumber)
  setJamNumber: (jamNumber) ->
    editingPenalty = this.getEditingPenalty()
    if !editingPenalty?
      editingPenalty = this.newPenaltyState()
      this.props.skaterState.penaltyStates.push(editingPenalty)
    editingPenalty.jamNumber = jamNumber
    this.setState(this.state)
    this.closeEdit()
  render: () ->
    containerClass = cx
      'skater-penalties': true
      'hidden': this.props.hidden
    <div className={containerClass}>
      <div className='row gutters-xs top-buffer actions' >
        <div className='col-sm-12 col-xs-12'>
          <button className='bt-btn btn-boxed action' onClick={this.props.backHandler} >
            <span className='icon glyphicon glyphicon-chevron-left'></span><strong>Back</strong>
          </button>
        </div>
      </div>
      <div className='row gutters-xs top-buffer'>
        <div className='col-sm-2 col-xs-2'>
          <div className='bt-btn btn-boxed' style={this.props.teamStyle}>
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
                penaltyState={this.findPenalty(1)}
                clickHandler={this.toggleEdit.bind(this, 1)}
                teamStyle={this.props.teamStyle} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl
                penaltyNumber={2}
                penaltyState={this.findPenalty(2)}
                clickHandler={this.toggleEdit.bind(this, 2)}
                teamStyle={this.props.teamStyle} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl
                penaltyNumber={3}
                penaltyState={this.findPenalty(3)}
                clickHandler={this.toggleEdit.bind(this, 3)}
                teamStyle={this.props.teamStyle} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl
                penaltyNumber={4}
                penaltyState={this.findPenalty(4)}
                clickHandler={this.toggleEdit.bind(this, 4)}
                teamStyle={this.props.teamStyle} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl
                penaltyNumber={5}
                penaltyState={this.findPenalty(5)}
                clickHandler={this.toggleEdit.bind(this, 5)}
                teamStyle={this.props.teamStyle} />
            </div>
            <div className='col-xs-2 col-sm-2'>
              <PenaltyControl
                penaltyNumber={6}
                penaltyState={this.findPenalty(6)}
                clickHandler={this.toggleEdit.bind(this, 6)}
                teamStyle={this.props.teamStyle} />
            </div>
          </div>
        </div>
        <div className='col-xs-2 col-sm-2'>
          <div className='penalty-7'>
            <PenaltyControl
              penaltyNumber={7}
              penaltyState={this.findPenalty(7)}
              clickHandler={this.toggleEdit.bind(this, 7)}
              teamStyle={this.props.teamStyle} />
          </div>
        </div>
      </div>
      <EditPenaltyPanel ref='editPenaltyPanel'
        penalty={this.getEditingPenalty() || this.newPenaltyState()}
        applyHandler={this.setJamNumber}
        cancelHandler={this.closeEdit}/>
    </div>