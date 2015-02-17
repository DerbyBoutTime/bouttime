exports = exports ? this
exports.PenaltyIndicator = React.createClass
  displayName: 'PenaltyIndicator'

  propTypes:
    penaltyNumber: React.PropTypes.number.isRequired
    penaltyState: React.PropTypes.object

  displayNumber: () ->
    switch this.props.penaltyNumber
      when 7 then 'Left Early'
      else this.props.penaltyNumber

  render: () ->
    <div className='penalty-indicator'>
      {this.displayNumber()}
    </div>