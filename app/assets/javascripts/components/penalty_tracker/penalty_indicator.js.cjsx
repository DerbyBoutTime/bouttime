exports = exports ? this
exports.PenaltyIndicator = React.createClass
  displayName: 'PenaltyIndicator'

  propTypes:
    penaltyNumber: React.PropTypes.number.isRequired
    penalty: React.PropTypes.object

  displayNumber: () ->
    switch this.props.penaltyNumber
      when 7 then 'Left Early'
      else this.props.penaltyNumber

  render: () ->
    <div class='penalty-indicator'>
      {this.displayNumber()}
    </div>