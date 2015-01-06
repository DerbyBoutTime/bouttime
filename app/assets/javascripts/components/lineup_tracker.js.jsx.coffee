cx = React.addons.classSet
exports = exports ? this
exports.LineupTracker = React.createClass
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

  getStandardOptions: (jam, isHomeTeam, skaterPosition, skaterId, opts) ->
    time: new Date()
    role: 'Lineup Tracker'
    jam: this.state.jamNumber
    team: if isHomeTeam then "home" else "away"
    skater_position: skaterPosition #0,1,2,3,4 (jammer, pivot/blocker, blocker, blocker blocker)
    skater_id: skaterId

  handleToggleTeam: (e) ->
    this.state.home.isSelected = !this.state.home.isSelected
    this.state.away.isSelected = !this.state.away.isSelected
    this.setState(this.state)

  render: () ->
    homeActiveTeamClass = cx
      'home': true
      'hidden-xs': !this.state.home.isSelected

    awayActiveTeamClass = cx
      'away': true
      'hidden-xs': !this.state.away.isSelected

    `<div className="lineup-tracker-view">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.away.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.state.away.name}
          </div>
        </div>
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.home.colorBarStyle} onClick={this.handleToggleTeam}>
            {this.state.home.name}
          </div>
        </div>
      </div>
      <div className="active-team">
        <div className="row gutters-xs">
          <div className="col-sm-6 col-xs-6">
            <div className={awayActiveTeamClass}></div>
          </div>
          <div className="col-sm-6 col-xs-6">
            <div className={homeActiveTeamClass}></div>
          </div>
        </div>
      </div>
      <div className="row gutters-xs jam-details">
        <div className="col-sm-6 col-xs-12" id="away-team">
          <div className="row gutters-xs jam-detail">
            <div className="col-sm-8 col-xs-8">
              <div className="jam-detail-number">
                <div className="row gutters-xs">
                  <div className="col-sm-11 col-xs-11 col-sm-offset-1 col-xs-offset-1">
                    Jam 1
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="jam-detail-no-pivot text-center">
                <strong>No Pivot</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="jam-detail-star-pass text-center">
                <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
              </div>
            </div>
          </div>
          <div className="row gutters-xs positions">
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
              <strong>Pivot</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>B1</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>B2</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>B3</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>J</strong>
            </div>
          </div>
          <div className="row gutters-xs skaters">
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2">
              <div className="skater text-center">
                2LBU
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater text-center">
                32
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater text-center">
                747
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater skater-injury text-center">
                1701
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater text-center">
                504
              </div>
            </div>
          </div>
          <div className="row gutters-xs boxes">
            <div className="col-sm-1 col-xs-1 col-sm-offset-1 col-xs-offset-1">
              <div className="box-toggle text-center">
                <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>X</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>/</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>$</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box box-injury text-center">
                <strong><span className="glyphicon glyphicon-paperclip"></span></strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>&nbsp;</strong>
              </div>
            </div>
          </div>
          <div className="row gutters-xs actions">
            <div className="col-sm-6 col-xs-6">
              <div className="actions-action actions-edit text-center">
                END
              </div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="actions-action actions-undo text-center">
                <strong>UNDO</strong>
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-6 col-xs-12 hidden-xs" id="home-team">
          <div className="row gutters-xs jam-detail">
            <div className="col-md-8 col-sm-6 col-xs-6">
              <div className="jam-detail-number">
                <div className="row gutters-xs">
                  <div className="col-sm-11 col-xs-11 col-sm-offset-1 col-xs-offset-1">
                    Jam 1
                  </div>
                </div>
              </div>
            </div>
            <div className="col-md-2 col-sm-3 col-xs-3">
              <div className="jam-detail-no-pivot text-center">
                <strong>No Pivot</strong>
              </div>
            </div>
            <div className="col-md-2 col-sm-3 col-xs-3">
              <div className="jam-detail-star-pass text-center">
                <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
              </div>
            </div>
          </div>
          <div className="row gutters-xs positions">
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
              <strong>Pivot</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>B1</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>B2</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>B3</strong>
            </div>
            <div className="col-sm-2 col-xs-2 text-center">
              <strong>J</strong>
            </div>
          </div>
          <div className="row gutters-xs skaters">
            <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2">
              <div className="skater-selector text-center">
                <strong><span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater-selector text-center">
                <strong><span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater-selector text-center">
                <strong><span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater-selector text-center">
                <strong><span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater-selector text-center">
                <strong><span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
              </div>
            </div>
          </div>
          <div className="row gutters-xs boxes">
            <div className="col-sm-1 col-xs-1 col-sm-offset-1 col-xs-offset-1">
              <div className="box-toggle text-center">
                <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>X</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>/</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>$</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>&nbsp;</strong>
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="box text-center">
                <strong>&nbsp;</strong>
              </div>
            </div>
          </div>
          <div className="row gutters-xs actions">
            <div className="col-sm-6 col-xs-6">
              <div className="actions-action actions-edit text-center">
                END
              </div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="actions-action actions-undo text-center">
                <strong>UNDO</strong>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>`
