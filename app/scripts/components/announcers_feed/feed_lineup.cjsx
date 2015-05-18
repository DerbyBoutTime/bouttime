React = require 'react/addons'
module.exports = React.createClass
  displayName: 'FeedLineup'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    <div className="feed-lineup">
      <div className='header btn-boxed text-center'>
        <strong>Lineup</strong>
      </div>
    </div>
