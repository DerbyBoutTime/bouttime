cx = React.addons.classSet
exports = exports ? this
exports.GameNotes = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    this.props
  render: () ->
    <div className="global-bout-notes"></div>
