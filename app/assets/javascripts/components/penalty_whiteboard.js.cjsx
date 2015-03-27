cx = React.addons.classSet
exports = exports ? this
exports.PenaltyWhiteboard = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    this.props
  render: () ->
    <div className="penalty-whiteboard">
      <span>Whiteboard</span>
    </div>
