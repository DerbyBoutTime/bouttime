cx = React.addons.classSet
exports = exports ? this
exports.GlobalBoutNotes = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div class="global-bout-notes"></div>`