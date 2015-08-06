React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'ScoreboardAlerts'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    text = switch
      when @props.gameState.state is 'timeout'
        @props.gameState.timeout
      when @props.gameState.state in ['unofficial final', 'official final']
        @props.gameState.state
    teamType = switch
      when @props.gameState.state is 'timeout' and @props.gameState.home.isTakingTimeoutOrOfficialReview()
        'home'
      when @props.gameState.state is 'timeout' and @props.gameState.away.isTakingTimeoutOrOfficialReview()
        'away'
    style = @props.gameState[teamType]?.colorBarStyle
    columnClass = cx
      'col-sm-12': not teamType?
      'col-sm-6': teamType?
      'col-sm-offset-6': teamType is 'away'
    <div className="row alerts">
      <div className={columnClass}>
        <div className='scoreboard-alert' style={style}>{text}</div>
      </div>
    </div>

