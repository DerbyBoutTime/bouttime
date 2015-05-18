React = require 'react/addons'
FeedLineupTeam = require './feed_lineup_team'
module.exports = React.createClass
  displayName: 'FeedLineup'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    game = @props.gameState
    home = @props.gameState.home
    away = @props.gameState.away
    <div className="feed-lineup">
      <div className='header boxed-good text-center'>
        <strong>Lineup</strong>
      </div>
      <FeedLineupTeam team={home}, jam={game.getCurrentJam(home)} />
      <FeedLineupTeam team={away}, jam={game.getCurrentJam(away)} />
    </div>
