cx = React.addons.classSet
exports = exports ? this
exports.EditPenaltyPanel = React.createClass
  displayName: 'EditPenaltyPanel'
  propTypes:
    penalty: React.PropTypes.object
    applyHandler: React.PropTypes.func
    cancelHandler: React.PropTypes.func
  incrementJamNumber: () ->
    @setState(jamNumber: @state.jamNumber + 1)
  decrementJamNumber: () ->
    @setState(jamNumber: Math.max(@state.jamNumber - 1, 0))
  resetState: () ->
    @state.dirty = true
  getInitialState: () ->
    jamNumber: @props.penalty.jamNumber
    dirty: false
  componentWillReceiveProps: (nextProps) ->
    if @state.dirty
      @setState
        jamNumber: nextProps.penalty.jamNumber
        dirty: false
  render: () ->
    classArgs =
      'edit-penalty collapse': true
    classArgs["penalty-#{@props.penalty.sort}"] = true
    containerClass = cx classArgs
    <div className={containerClass} id='edit-penalty-panel'>
      <div className='row gutters-xs'>
        <div className='col-sm-1 col-xs-1 col-sm-offset-1 col-xs-offset-1'>
          <button className='bt-btn btn-boxed apply' onClick={@props.applyHandler.bind(null, @state.jamNumber)}>
            <span className='glyphicon glyphicon-ok'></span>
          </button>
        </div>
        <div className='col-sm-8 col-xs-8'>
          <div className='jam-number-control boxed-good'>
            <button className='btn btn-boxed minus' onClick={@decrementJamNumber}>
              <span className='glyphicon glyphicon-minus'></span>
            </button>
            <strong>Jam {@state.jamNumber}</strong>
            <button className='btn btn-boxed plus' onClick={@incrementJamNumber}>
              <span className='glyphicon glyphicon-plus'></span>
            </button>
          </div>
        </div>
        <div className='col-sm-1 col-xs-1'>
          <button className='bt-btn btn-boxed cancel' onClick={@props.cancelHandler}>
            <span className='glyphicon glyphicon-remove'></span>
          </button>
        </div>
      </div>
    </div>
