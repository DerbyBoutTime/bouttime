cx = React.addons.classSet
exports = exports ? this

exports.ScoreNote = React.createClass
  displayName: 'ScoreNote'

  propTypes:
  	note: React.PropTypes.string

  noteContent: () ->
    switch this.props.note
      when 'injury' then 'Injury'
      when 'calloff' then 'Call'
      when 'nopass' then 'No P.'
      when 'lead' then 'Lead'
      when 'lost' then 'Lost'
      else <span>&nbsp;</span>

  render: () ->
    noteClassArgs = 
      'selected': this.props.note?
      'boxed-good text-center notes': true
    noteClassArgs[this.props.note] = true

    noteClass = cx noteClassArgs
    
    <div className={noteClass}>
      <strong>{this.noteContent()}</strong>
    </div>
