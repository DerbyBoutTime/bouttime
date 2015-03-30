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
    @setState(selectedTeam: teamType)
  containerClass: (teamType) ->
    cx
      'col-sm-6 col-xs-12': true
      'hidden-xs': @state.selectedTeam != teamType
  getInitialState: () ->
    selectedTeam: 'away'
  render: () ->
    displayBoth = window.matchMedia('(min-width: 768px)').matches
    awayStyle = if @state.selectedTeam is 'away' or displayBoth then @props.awayAttributes.colorBarStyle else {}
    homeStyle = if @state.selectedTeam is 'home' or displayBoth then @props.homeAttributes.colorBarStyle else {}
    <div className="team-selector">
      <div className="row teams gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <button className="team-name bt-btn btn-boxed" style={awayStyle} onClick={@selectTeam.bind(this, 'away')}>
            {@props.awayAttributes.name}
          </button>
        </div>
        <div className="col-sm-6 col-xs-6">
          <button className="team-name bt-btn btn-boxed" style={homeStyle} onClick={@selectTeam.bind(this, 'home')}>
            {@props.homeAttributes.name}
          </button>
        </div>
      </div>
      <div className="row gutters-xs">
        <div className={@containerClass('away')}>
          {@props.awayElement}
        </div>
        <div className={@containerClass('home')}>
          {@props.homeElement}
        </div>
      </div>
    </div>