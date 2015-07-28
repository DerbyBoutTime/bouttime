React = require 'react/addons'
FeedLineupTeam = require './announcers_feed/feed_lineup_team'
FeedItem = require './announcers_feed/feed_item'
module.exports = React.createClass
  displayName: 'AnnouncersFeed'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    game = @props.gameState
    home = game.home
    away = game.away
    <div className="announcers-feed">
      <div className="row gutters-xs">
        <div className="col-xs-3 col-sm-3">
          <div className='bt-box box-primary text-center'>
            <strong>Lineup</strong>
          </div>
          <FeedLineupTeam team={home}, jam={game.getCurrentJam(home)} />
          <FeedLineupTeam team={away}, jam={game.getCurrentJam(away)} />
        </div>
        <div className="col-xs-9 col-sm-9">
          <div className='bt-box box-primary text-center'>
            <strong>Actions</strong>
          </div>
          {@props.gameState.feed.map (item) ->
            <FeedItem key={item.id}, item={item} />
          }
        </div>
      </div>
    </div>
