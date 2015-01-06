cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
  getStandardOptions: (jam, isHomeTeam, skaterPosition, skaterId, opts) ->
    time: new Date()
    role: 'Lineup Tracker'
    jam: this.state.jamNumber
    team: if isHomeTeam then "home" else "away"
    skater_position: skaterPosition #0,1,2,3,4 (jammer, pivot/blocker, blocker, blocker blocker)
    skater_id: skaterId
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
    $dom.on 'click', '.toggle-star-pass-btn', null, (evt) =>
      exports.dispatcher.trigger "lineup_tracker.toggle_star_pass", this.getStandardOptions()
    $dom.on 'click', '.toggle-pivot-btn', null, (evt) =>
      exports.dispatcher.trigger "lineup_tracker.toggle_pivot", this.getStandardOptions()
    $dom.on 'click', '.skater-btn', null, (evt) =>
      exports.dispatcher.trigger "lineup_tracker.set_skater", this.getStandardOptions()
    $dom.on 'click', '.skate-state-btn', null, (evt) =>
      exports.dispatcher.trigger "lineup_tracker.toggle_skater_state", this.getStandardOptions()
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div className="lineup-tracker">
      <section className="team-toggle">
        <div className="row teams text-center gutters-xs">
          <div className="col-sm-6 col-xs-6">
            <div className="team-name" style={this.state.awayAttributes.colorBarStyle} >
              {this.state.awayAttributes.name}
            </div>
          </div>
          <div className="col-sm-6 col-xs-6">
            <div className="team-name" style={this.state.homeAttributes.colorBarStyle}>
              {this.state.homeAttributes.name}
            </div>
          </div>
        </div>
        <div className="active-team">
          <div className="row gutters-xs">
            <div className="col-sm-6 col-xs-6">
              <div className="away"></div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="home hidden-xs"></div>
            </div>
          </div>
        </div>
      </section>
    </div>`