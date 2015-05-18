React = require 'react/addons'
module.exports = React.createClass
  displayName: 'FeedActions'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  render: () ->
    <div className="feed-actions">
      <div className='header btn-boxed text-center'>
        <strong>Actions</strong>
      </div>
    </div>