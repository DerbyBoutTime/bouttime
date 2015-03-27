cx = React.addons.classSet
exports = exports ? this
exports.LineupBox = React.createClass
  displayName: 'LineupBox'

  propTypes:
    status: React.PropTypes.string

  getDefaultProps: () ->
    status: 'clear'

  boxContent: () ->
    switch this.props.status
      when 'clear' then <span>&nbsp;</span>
      when null then <span>&nbsp;</span>
      when 'went_to_box' then '/'
      when 'went_to_box_and_released' then 'X'
      when 'injured' then <span className="glyphicon glyphicon-paperclip"></span>
      when 'sat_in_box' then  'S'
      when 'sat_in_box_and_released' then '$'

  render: () ->
    injuryClass = cx
      'box-injury': this.props.status is 'injured'

    <button className={injuryClass + " box text-center btn btn-block btn-box"} onClick={this.props.lineupStatusHandler}>
      <strong>{this.boxContent()}</strong>
    </button>

