cx = React.addons.classSet
exports = exports ? this
exports.PenaltyControl = React.createClass
  render: () ->

  propTypes:
    penaltyNumber: React.PropTypes.number.isRequired
    penaltyState: React.PropTypes.object

  render: () ->
    <div className='penalty-control'>
      <div className='jam-number'>
        <strong>Jam</strong>
      </div>
      <button className='btn btn-block btn-boxed penalty-indicator'>
        {this.props.penaltyNumber}
      </button>
    </div>