React = require 'react/addons'
tinycolor = require 'tinycolor2'
module.exports = React.createClass
  displayName: 'FeedItem'
  propTypes:
    item: React.PropTypes.object.isRequired
  renderTwoColumn: (icon, body, style) ->
    <div className='row gutters-xs top-buffer'>
      <div className='col-xs-1'>
        <div className='bt-box text-center' style={style}>
          {icon}
        </div>
      </div>
      <div className='col-xs-11'>
        <div className='bt-box'>
          {body}
        </div>
      </div>
    </div>
  render: () ->
    notLeadStyle = () =>
      style = @props.item.style
      backgroundColor: style.backgroundColor
      borderColor: style.borderColor
      color: tinycolor(style.backgroundColor).lighten(20).toString()
    hasLead = () =>
      passes = @props.item.jam.passes
      lead = passes.some (pass) ->
        pass.lead
      lost = passes.some (pass) ->
        pass.lostLead
      lead and not lost
    switch @props.item.type
      when 'jam start'
        <div className='bt-box box-default text-center top-buffer'>Jam {@props.item.jamNumber} Starts</div>
      when 'timeout'
        <div className='bt-box box-warning text-center top-buffer uppercase' style={@props.item.style}>{@props.item.body}</div>
      when 'penalty'
        @renderTwoColumn(
          @props.item.penalty.code,
          <span><span style={color: @props.item.style.backgroundColor}>{@props.item.skater?.number} {@props.item.skater?.name}</span> - Penalty: {@props.item.penalty.name}</span>,
          @props.item.style
        )
      when 'lead'
        @renderTwoColumn(
          <span className='glyphicon glyphicon-star'></span>, 
          <span><span style={color: @props.item.style.backgroundColor}>{@props.item.skater?.number} {@props.item.skater?.name}</span> - Lead Jammer</span>,
          @props.item.style
        )
      when 'lost lead'
        @renderTwoColumn(
          <span className='glyphicon glyphicon-star'></span>, 
          <span><span style={color: @props.item.style.backgroundColor}>{@props.item.skater?.number} {@props.item.skater?.name}</span> - Lost Lead</span>,
          notLeadStyle()
        )
      when 'calloff'
        @renderTwoColumn(
          <span className='glyphicon glyphicon-star'></span>, 
          <span><span style={color: @props.item.style.backgroundColor}>{@props.item.skater?.number} {@props.item.skater?.name}</span> - Calls the Jam</span>,
          @props.item.style
        )
      when 'points'
        @renderTwoColumn(
          <span className='glyphicon glyphicon-star'></span>, 
          <span><span style={color: @props.item.style.backgroundColor}>{@props.item.pass.jammer?.number} {@props.item.pass.jammer?.name}</span> - {@props.item.pass.points} Points (Pass {@props.item.pass.passNumber})</span>,
          if hasLead() then @props.item.style else notLeadStyle()
        )