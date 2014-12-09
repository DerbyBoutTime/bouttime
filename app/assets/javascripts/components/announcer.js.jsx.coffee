cx = React.addons.classSet
exports = exports ? this
exports.AnnouncerFeed = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div class="announcer-feed"></div>`
