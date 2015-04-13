React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'ScoreNote'
  propTypes:
  	note: React.PropTypes.string
  noteContent: () ->
    switch @props.note
      when 'injury' then 'Injury'
      when 'calloff' then 'Call'
      when 'nopass' then 'No P.'
      when 'lead' then 'Lead'
      when 'lost' then 'Lost'
      else <span>&nbsp;</span>
  render: () ->
    noteClassArgs =
      'selected': @props.note?
      'boxed-good text-center notes': true
    noteClassArgs[@props.note] = true
    noteClass = cx noteClassArgs

    <div className={noteClass}>
      <strong>{@noteContent()}</strong>
    </div>
