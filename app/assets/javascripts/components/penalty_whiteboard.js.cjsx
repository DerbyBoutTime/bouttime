cx = React.addons.classSet
exports = exports ? this
exports.PenaltyWhiteboard = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    <div className="penalty-whiteboard"></div>
