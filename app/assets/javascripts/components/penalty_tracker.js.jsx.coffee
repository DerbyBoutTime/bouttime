cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div class="penalty-tracker"></div>`