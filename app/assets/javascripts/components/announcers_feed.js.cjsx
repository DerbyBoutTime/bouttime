cx = React.addons.classSet
exports = exports ? this
exports.AnnouncersFeed = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    this.props
  render: () ->
    <div className="announcers-feed"></div>
