cx = React.addons.classSet
exports = exports ? this
exports.GameNotes = React.createClass
  componentDidMount: () ->
    $dom = $(@getDOMNode())
  getInitialState: () ->
    @props
  render: () ->
    <div className="global-bout-notes"></div>
