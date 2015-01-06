cx = React.addons.classSet
exports = exports ? this
exports.AnnouncersFeed = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div className="announcers-feed"></div>`
