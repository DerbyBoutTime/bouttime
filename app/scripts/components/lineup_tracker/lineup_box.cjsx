React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupBox'
  propTypes:
    status: React.PropTypes.string
    cycleLineupStatus: React.PropTypes.func
  getDefaultProps: () ->
    status: 'clear'
  boxContent: () ->
    switch @props.status
      when 'clear' then <span>&nbsp;</span>
      when null then <span>&nbsp;</span>
      when 'went_to_box' then '/'
      when 'went_to_box_and_released' then 'X'
      when 'injured' then <span className="glyphicon glyphicon-paperclip"></span>
      when 'sat_in_box' then  'S'
      when 'sat_in_box_and_released' then '$'
      when 'continuing_penalty' then '|'
      when 'continuing_penalty_and_released' then '+'
  render: () ->
    injuryClass = cx
      'box-injury': @props.status is 'injured'
    <button className={injuryClass + " box text-center bt-btn btn-box"} onClick={@props.cycleLineupStatus}>
      <strong>{@boxContent()}</strong>
    </button>
