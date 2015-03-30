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
    workingSkaterState: $.extend(true, {}, @props.skaterState)
    editingPenaltyNumber: null
  resetState: (callback) ->
    @dirty = true
  componentWillReceiveProps: (nextProps) ->
    if @dirty
      @dirty = false
      $('#edit-penalty-panel').collapse('hide')
      @setState
        workingSkaterState: $.extend(true, {}, nextProps.skaterState)
        editingPenaltyNumber: null

  findPenalty: (penaltyNumber) ->
    matches = (penalty for penalty in @state.workingSkaterState.penaltyStates when penalty.sort is penaltyNumber)
    matches[0]

  getEditingPenalty: () ->
    @findPenalty(@state.editingPenaltyNumber)
  newPenaltyState: () ->
    jamNumber: @props.currentJamNumber
    sort: @state.editingPenaltyNumber
  editPenaltyState: (penaltyNumber) ->
    @setState(editingPenaltyNumber: penaltyNumber)
    @refs.editPenaltyPanel.resetState()
    $('#edit-penalty-panel').collapse('show')
  closeEdit: () ->
    @setState(editingPenaltyNumber: null)
    $('#edit-penalty-panel').collapse('hide')
  toggleEdit: (penaltyNumber) ->
    if @state.editingPenaltyNumber? then @closeEdit() else @editPenaltyState(penaltyNumber)
  setJamNumber: (jamNumber) ->
    editingPenalty = @getEditingPenalty()
    if !editingPenalty?
      editingPenalty = @newPenaltyState()
      @state.workingSkaterState.penaltyStates.push(editingPenalty)
    editingPenalty.jamNumber = jamNumber
    @setState(@state)
    @closeEdit()
  setPenalty: (penaltyIndex) ->
    return if !@state.editingPenaltyNumber?
    selectedPenalty = @props.penalties[penaltyIndex]
    editingPenaltyState = @getEditingPenalty()
    if !editingPenaltyState?
      editingPenaltyState = @newPenaltyState()
      @state.workingSkaterState.penaltyStates.push(editingPenaltyState)
    if editingPenaltyState.penalty? and editingPenaltyState.penalty.name is selectedPenalty.name
      @state.workingSkaterState.penaltyStates = @state.workingSkaterState.penaltyStates.filter (ps) ->
        ps.sort isnt editingPenaltyState.sort
    else
      editingPenaltyState.penalty = selectedPenalty
    @setState(@state)
  render: () ->
    containerClass = cx
      'skater-penalties': true
      'hidden': @props.hidden
    if @props.skaterState?
      <div className={containerClass}>
        <div className='row gutters-xs top-buffer actions' >
          <div className='col-sm-6 col-xs-6'>
            <button className='bt-btn btn-boxed action apply' onClick={@props.applyHandler.bind(null, @state.workingSkaterState)} >
              <span className='icon glyphicon glyphicon-ok'></span><strong>Apply</strong>
            </button>
          </div>
          <div className='col-sm-6 col-xs-6'>
            <button className='bt-btn btn-boxed action cancel' onClick={@props.cancelHandler}>
              <span className='icon glyphicon glyphicon-remove'></span><strong>Cancel</strong>
            </button>
          </div>
        </div>
        <div className='row gutters-xs top-buffer'>
          <div className='col-sm-2 col-xs-2'>
            <div className='bt-btn btn-boxed' style={@props.teamStyle}>
              <strong>{@props.skaterState.skater.number}</strong>
            </div>
          </div>
        </div>
        <div className='row gutters-xs top-buffer penalty-controls'>
          <div className='col-xs-10 col-sm-10'>
            <div className='row gutters-xs'>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={1}
                  penaltyState={@findPenalty(1)}
                  clickHandler={@toggleEdit.bind(this, 1)}
                  teamStyle={@props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={2}
                  penaltyState={@findPenalty(2)}
                  clickHandler={@toggleEdit.bind(this, 2)}
                  teamStyle={@props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={3}
                  penaltyState={@findPenalty(3)}
                  clickHandler={@toggleEdit.bind(this, 3)}
                  teamStyle={@props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={4}
                  penaltyState={@findPenalty(4)}
                  clickHandler={@toggleEdit.bind(this, 4)}
                  teamStyle={@props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={5}
                  penaltyState={@findPenalty(5)}
                  clickHandler={@toggleEdit.bind(this, 5)}
                  teamStyle={@props.teamStyle} />
              </div>
              <div className='col-xs-2 col-sm-2'>
                <PenaltyControl
                  penaltyNumber={6}
                  penaltyState={@findPenalty(6)}
                  clickHandler={@toggleEdit.bind(this, 6)}
                  teamStyle={@props.teamStyle} />
              </div>
            </div>
          </div>
          <div className='col-xs-2 col-sm-2'>
            <div className='penalty-7'>
              <PenaltyControl
                penaltyNumber={7}
                penaltyState={@findPenalty(7)}
                clickHandler={@toggleEdit.bind(this, 7)}
                teamStyle={@props.teamStyle} />
            </div>
          </div>
        </div>
        <EditPenaltyPanel ref='editPenaltyPanel'
          penalty={@getEditingPenalty() || @newPenaltyState()}
          applyHandler={@setJamNumber}
          cancelHandler={@closeEdit}/>
        <div className='penalties-list'>
          {@props.penalties[0...-1].map((penalty, penaltyIndex) ->
            <div key={penaltyIndex} className='penalty'>
              <div className='col-xs-1 col-sm-1'>
                <button className='penalty-code bt-btn btn-boxed' onClick={@setPenalty.bind(this, penaltyIndex)}>
                  <strong>{penalty.code}</strong>
                </button>
              </div>
              <div className='col-xs-5 col-sm-5'>
                <button className='penalty-name bt-btn btn-boxed' onClick={@setPenalty.bind(this, penaltyIndex)}>
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
              <button className='penalty-code bt-btn btn-boxed' onClick={@setPenalty.bind(this, @props.penalties.length - 1)}>
                <strong>{@props.penalties[@props.penalties.length - 1].code}</strong>
              </button>
            </div>
            <div className='col-xs-11 col-sm-11'>
              <button className='penalty-name bt-btn btn-boxed' onClick={@setPenalty.bind(this, @props.penalties.length - 1)}>
                <strong>{@props.penalties[@props.penalties.length - 1].name} - Expulsion</strong>
              </button>
            </div>
          </div>
        </div>
      </div>
    else
      <div className={containerClass}></div>