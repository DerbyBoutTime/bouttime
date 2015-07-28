React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'ScoreboardTeam'
  propTypes:
    team: React.PropTypes.object.isRequired
    jam: React.PropTypes.object
  render: () ->
    leadClass = cx
      'glyphicon': true
      'glyphicon-star': true
      'hidden': not @props.jam?.passes?[0]?.lead or @props.jam?.passes?.some (pass) -> pass.lostLead
    officialReviewClass = cx
      'official-review': true
      'timeout-bar': true
      'active': @props.team.isTakingOfficialReview
      'inactive': @props.team.hasOfficialReview == false
    timeoutClass = (num) => cx
      'timeout-bar': true
      'timeout': true
      'active': @props.team.isTakingTimeout && @props.team.timeouts is 3 - num
      'inactive': @props.team.timeouts < 4 - num
    <div className="team">
      <div className="logo">
        <img src={@props.team.logo} />
      </div>
      <div className="team-name">{@props.team.name}</div>
      <div className="color-bar" style={@props.team.colorBarStyle}></div>
      <div className="score">{@props.team.getPoints()}</div>
      <div className="jammer reversible">
        <div className="lead-status">
          <span className={leadClass} style={color: @props.team.colorBarStyle.backgroundColor}></span>
        </div>
        <div className="jammer-name">{if @props.jam?.jammer then "#{@props.jam.jammer.number} #{@props.jam.jammer.name}"}</div>
      </div>
      <div className="timeouts reversible">
        <div className={officialReviewClass} style={@props.team.colorBarStyle}></div>
        <div className={timeoutClass(1)} style={@props.team.colorBarStyle}></div>
        <div className={timeoutClass(2)} style={@props.team.colorBarStyle}></div>
        <div className={timeoutClass(3)} style={@props.team.colorBarStyle}></div>
      </div>
    </div>
