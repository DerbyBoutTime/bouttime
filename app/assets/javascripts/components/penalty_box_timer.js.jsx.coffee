cx = React.addons.classSet
exports = exports ? this
exports.PenaltyBoxTimer = React.createClass
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div className="penalty-box-timer">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.awayAttributes.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.state.awayAttributes.name}
          </div>
        </div>
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.homeAttributes.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.state.homeAttributes.name}
          </div>
        </div>
      </div>
    </div>`
