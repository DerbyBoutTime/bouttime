React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  componentDidMount: () ->
    $dom = $(@getDOMNode())
  getInitialState: () ->
    @props
  render: () ->
    <div className="announcers-feed">
      <span>Announcers Feed</span>
    </div>
