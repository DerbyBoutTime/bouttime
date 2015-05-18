React = require 'react/addons'
FeedLineup = require './announcers_feed/feed_lineup'
FeedActions = require './announcers_feed/feed_actions'
module.exports = React.createClass
  displayName: 'AnnouncersFeed'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    <div className="announcers-feed">
      <div className="row gutters-xs">
        <div className="col-xs-3 col-sm-3">
          <FeedLineup {...@props} />
        </div>
        <div className="col-xs-9 col-sm-9">
          <FeedActions {...@props} />
        </div>
      </div>
    </div>
