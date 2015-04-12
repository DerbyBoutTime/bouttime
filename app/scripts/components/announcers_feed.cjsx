cx = React.addons.classSet
exports = exports ? this
exports.AnnouncersFeed = React.createClass
  componentDidMount: () ->
    $dom = $(@getDOMNode())
  getInitialState: () ->
    @props
  render: () ->
    <div className="announcers-feed">
      <span>Announcers Feed</span>
    </div>
