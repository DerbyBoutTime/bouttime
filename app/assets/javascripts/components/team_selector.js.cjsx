cx = React.addons.classSet
exports = exports ? this
exports.TeamSelector = React.createClass
  displayName: 'TeamSelector'

  propTypes:
    awayAttributes: React.PropTypes.object.isRequired
    awayElement: React.PropTypes.element.isRequired
    homeAttributes: React.PropTypes.object.isRequired
    homeElement: React.PropTypes.element.isRequired

  selectTeam: (teamType) ->
    this.setState(selectedTeam: teamType)

  containerClass: (teamType) ->
    cx
      'col-sm-6 col-xs-12': true
      'hidden-xs': this.state.selectedTeam != teamType

  getInitialState: () ->
    selectedTeam: 'away'

  render: () ->
    displayBoth = window.matchMedia('(min-width: 768px)').matches
    awayStyle = if this.state.selectedTeam is 'away' or displayBoth then this.props.awayAttributes.colorBarStyle else {}
    homeStyle = if this.state.selectedTeam is 'home' or displayBoth then this.props.homeAttributes.colorBarStyle else {}
    <div className="team-selector">
      <div className="row teams gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <button className="team-name btn btn-block btn-boxed" style={awayStyle} onClick={this.selectTeam.bind(this, 'away')}>
            {this.props.awayAttributes.name}
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="team-name btn btn-block btn-boxed" style={homeStyle} onClick={this.selectTeam.bind(this, 'home')}>
            {this.props.homeAttributes.name}
          </button>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className={this.containerClass('away')}>
          {this.props.awayElement}
        </div>
        <div className={this.containerClass('home')}>
          {this.props.homeElement}
        </div>
      </div>
    </div>