React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'FeedLineupTeam'
  propTypes:
    team: React.PropTypes.object.isRequired
    jam: React.PropTypes.object.isRequired
  render: () ->
    team = @props.team
    jam = @props.jam
    jammerClass = cx
      'glyphicon glyphicon-star': jam?.jammer? and not jam?.starPass
    pivotClass = cx
      'glyphicon glyphicon-minus-sign': jam?.pivot? and not jam?.noPivot and not jam?.starPass
      'glyphicon glyphicon-star': jam?.pivot? and jam?.starPass
    <div className="feed-lineup-team">
      <div className='header boxed-good text-center' style={team.colorBarStyle}>
        <strong>{team.initials}</strong>
      </div>
      <div className='header boxed-good text-center' style={team.colorBarStyle}>
        <span className={jammerClass}></span><strong>{jam?.jammer?.number}</strong>
      </div>      
      <div className='header boxed-good text-center' style={team.colorBarStyle}>
        <span className={pivotClass}></span><strong>{jam?.pivot?.number}</strong>
      </div>      
      <div className='header boxed-good text-center' style={team.colorBarStyle}>
        <strong>{jam?.blocker1?.number}</strong>
      </div>      
      <div className='header boxed-good text-center' style={team.colorBarStyle}>
        <strong>{jam?.blocker2?.number}</strong>
      </div>      
      <div className='header boxed-good text-center' style={team.colorBarStyle}>
        <strong>{jam?.blocker3?.number}</strong>
      </div>      
    </div>
