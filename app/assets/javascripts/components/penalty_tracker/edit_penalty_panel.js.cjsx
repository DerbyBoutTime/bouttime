cs = React.addons.classSet
exports = exports ? this
exports.EditPenaltyPanel = React.createClass
  displayName: 'EditPenaltyPanel'

  propTypes:
    penalty: React.PropTypes.object
    applyHandler: React.PropTypes.func
    cancelHandler: React.PropTypes.func

  incrementJamNumber: () ->
    this.setState(jamNumber: this.state.jamNumber + 1)

  decrementJamNumber: () ->
    this.setState(jamNumber: Math.max(this.state.jamNumber - 1, 0))

  resetState: () ->
    this.state.dirty = true

  getInitialState: () ->
    jamNumber: this.props.penalty.jamNumber
    dirty: false

  componentWillReceiveProps: (nextProps) ->
    if this.state.dirty
      this.setState
        jamNumber: nextProps.penalty.jamNumber
        dirty: false

  render: () ->
    <div className='edit-penalty collapse' id='edit-penalty-panel'>
      <div className='row gutters-xs'>
        <div className='col-sm-1 col-xs-1'>
          <button className='btn btn-block btn-boxed apply' onClick={this.props.applyHandler.bind(null, this.state.jamNumber)}>
            <span className='glyphicon glyphicon-ok'></span>
          </button>
        </div>
        <div className='col-sm-8 col-xs-8'>
          <div className='jam-number-control'>
            <button className='minus' onClick={this.decrementJamNumber}>
              <span className='glyphicon glyphicon-minus'></span>
            </button>
            <strong>Jam {this.state.jamNumber}</strong>
            <button className='plus' onClick={this.incrementJamNumber}>
              <span className='glyphicon glyphicon-plus'></span>
            </button>  
          </div>
        </div>
        <div className='col-sm-1 col-xs-1'>
          <button className='btn btn-block btn-boxed cancel' onClick={this.props.cancelHandler}>
            <span className='glyphicon glyphicon-remove'></span>
          </button>
        </div>
      </div>
    </div>
