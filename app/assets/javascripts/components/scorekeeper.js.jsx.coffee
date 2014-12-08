exports = exports ? this
exports.Scorekeeper = React.createClass
  getInitialState: () ->
    jamNumber: 1
    team:
      home:
        name: "Atlanta Rollergirls"
        colorTabStyle:
          backgroundColor: "#2082a6"
        points: 0
        jamPoints: 0
        hasOfficialReview: true
        timeouts: 3
        jammer:
          lead: false
          name: "Nattie Long Legs"
          number: 1234
      away:
        name: "Gotham Rollergirls"
        colorTabStyle:
          backgroundColor: "#f50031"
        points: 0
        jamPoints: 0
        hasOfficialReview: true
        timeouts: 3
        jammer:
          lead: true
          name: "Bonnie Thunders"
          number: 4567
        passes:
          passOne:
            number: 1
            skaterNumber: 1234
            injury: false

  render: () ->
    `<div id="scorekeeper-view">
      <div className="row teams text-center gutters-xs">
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.team.away.colorTabStyle} >
            {this.state.team.away.name}
          </div>
        </div>
        <div className="col-sm-6 col-xs-6">
          <div className="team-name" style={this.state.team.home.colorTabStyle}>
            {this.state.team.home.name}
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
      <div className="row gutters-xs">
        <div className="col-sm-6 col-xs-12" id="away-team">
          <div className="row stats gutters-xs">
            <div className="col-sm-6 col-xs-6">
              <div className="stat current-jam">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Current Jam</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right current-jam-score">
                    <strong>{this.state.jamNumber}</strong>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="stat game-total">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Game Total</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right game-total-score">
                    <strong>{this.state.team.away.points}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="jams">
            <div className="headers">
              <div className="row gutters-xs">
                <div className="col-sm-2 col-xs-2">
                  <strong>Jam</strong>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <strong>Skater</strong>
                </div>
                <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Notes</strong>
                </div>
                <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Points</strong>
                </div>
              </div>
            </div>
            <div className="columns">
              <div className="row gutters-xs">
                <div className="col-sm-2 col-xs-2">
                  <div className="jam text-center">
                    {this.state.jamNumber}
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="skater">
                    {this.state.team.away.jammer.number}
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="notes injury text-center">
                    Injury
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="notes call text-center">
                    Call
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="notes lost text-center">
                    Lost
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="points text-center">
                    10
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="links">
            <div className="row text-center gutters-xs">
              <div className="col-sm-6 col-xs-6">
                <div className="link main-menu">
                  MAIN MENU
                </div>
              </div>
              <div className="col-sm-6 col-xs-6">
                <div className="row gutters-xs">
                  <div className="col-sm-5 col-xs-5 col-sm-offset-1 col-xs-offset-1">
                    <div className="link prev">
                      PREV
                    </div>
                  </div>
                  <div className="col-sm-6 col-xs-6">
                    <div className="link next">
                      NEXT
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="jam-details">
            <div className="row gutters-xs">
              <div className="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
                <div className="jam-number">
                  <strong>Jam 5</strong>
                </div>
              </div>
              <div className="col-sm-3 col-xs-3 text-right">
                <div className="jam-total-score">
                  <strong>0</strong>
                </div>
              </div>
            </div>
          </div>
          <div className="passes">
            <div className="headers">
              <div className="row gutters-xs">
                <div className="col-sm-2 col-xs-2">
                  Pass
                </div>
                <div className="col-sm-2 col-xs-2">
                  Skater
                </div>
                <div className="col-sm-2 col-xs-2"></div>
                <div className="col-sm-2 col-xs-2 text-center">
                  Notes
                </div>
                <div className="col-sm-2 col-xs-2"></div>
                <div className="col-sm-2 col-xs-2 text-center">
                  Points
                </div>
              </div>
            </div>
            <div aria-multiselectable="true" id="away-team-pass-1">
              <div className="columns">
                <div className="row gutters-xs">
                  <div className="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-number-1" aria-expanded="false" className="pass text-center" data-parent="#away-team-pass-1" data-toggle="collapse" href="#away-team-edit-pass-number-1">
                      {this.state.team.away.passes.passOne.number}
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="skater">
                      {this.state.team.away.passes.passOne.skaterNumber}
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="notes injury text-center">
                      Injury
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="notes call text-center">
                      Call
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="notes lost text-center">
                      Lost
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-1" aria-expanded="false" className="points text-center" data-parent="#away-team-pass-1" data-toggle="collapse" href="#away-team-edit-pass-1">
                      10
                    </div>
                  </div>
                </div>
              </div>
              <div className="panel">
                <div className="edit-pass-number collapse" id="away-team-edit-pass-number-1">
                  <div className="row gutters-xs">
                    <div className="col-sm-1 col-xs-1">
                      <div className="remove text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="minus text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="plus text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="ok text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="panel">
                <div className="edit-pass first-pass collapse" id="away-team-edit-pass-1">
                  <div className="row gutters-xs">
                    <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                      <div className="remove text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes injury text-center">
                        Injury
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes note-lead text-center">
                        Lead
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes call text-center">
                        Call
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="ok text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                  <div className="row gutters-xs">
                    <div className="col-sm-2 col-xs-2 col-sm-offset-3 col-xs-offset-3">
                      <div className="zero text-center">
                        0
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="one text-center">
                        1
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes no-pass text-center">
                        No P.
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div aria-multiselectable="true" id="away-team-pass-2">
              <div className="columns">
                <div className="row gutters-xs">
                  <div className="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-number-2" aria-expanded="false" className="pass text-center" data-parent="#away-team-pass-2" data-toggle="collapse" href="#away-team-edit-pass-number-2">
                      1
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="skater">
                      1234
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="notes injury text-center">
                      Injury
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="notes call text-center">
                      Call
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div className="notes lost text-center">
                      Lost
                    </div>
                  </div>
                  <div className="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-2" aria-expanded="false" className="points text-center" data-parent="#away-team-pass-2" data-toggle="collapse" href="#away-team-edit-pass-2">
                      5
                    </div>
                  </div>
                </div>
              </div>
              <div className="panel">
                <div className="edit-pass-number collapse" id="away-team-edit-pass-number-2">
                  <div className="row gutters-xs">
                    <div className="col-sm-1 col-xs-1">
                      <div className="remove text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="minus text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="plus text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="ok text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="panel">
                <div className="edit-pass second-pass collapse" id="away-team-edit-pass-2">
                  <div className="row gutters-xs">
                    <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                      <div className="remove text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes injury text-center">
                        Injury
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes note-lead text-center">
                        Lead
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="notes call text-center">
                        Call
                      </div>
                    </div>
                    <div className="col-sm-2 col-xs-2">
                      <div className="ok text-center">
                        <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                  <div className="row gutters-xs">
                    <div className="col-sm-1 col-xs-1 col-sm-offset-2 col-xs-offset-2">
                      <div className="zero text-center">
                        0
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="one text-center">
                        1
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="two text-center">
                        2
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="three text-center">
                        3
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="four text-center">
                        4
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="five text-center">
                        5
                      </div>
                    </div>
                    <div className="col-sm-1 col-xs-1">
                      <div className="six text-center">
                        6
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="col-sm-6 col-xs-12 hidden-xs" id="home-team">
          <div className="row stats gutters-xs">
            <div className="col-sm-6 col-xs-6">
              <div className="stat current-jam">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Current Jam</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right current-jam-score">
                    <strong>{this.state.jamNumber}</strong>
                  </div>
                </div>
              </div>
            </div>
            <div className="col-sm-6 col-xs-6">
              <div className="stat game-total">
                <div className="row gutters-xs">
                  <div className="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Game Total</strong>
                  </div>
                  <div className="col-sm-2 col-xs-2 text-right game-total-score">
                    <strong>{this.state.team.home.points}</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="jams">
            <div className="headers">
              <div className="row gutters-xs">
                <div className="col-sm-2 col-xs-2">
                  <strong>Jam</strong>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <strong>Skater</strong>
                </div>
                <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Notes</strong>
                </div>
                <div className="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Points</strong>
                </div>
              </div>
            </div>
            <div className="columns">
              <div className="row gutters-xs">
                <div className="col-sm-2 col-xs-2">
                  <div className="jam text-center">
                    1
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="skater">
                    1234
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="notes injury text-center">
                    Injury
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="notes call text-center">
                    Call
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="notes lost text-center">
                    Lost
                  </div>
                </div>
                <div className="col-sm-2 col-xs-2">
                  <div className="points text-center">
                    10
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="links">
            <div className="row text-center gutters-xs">
              <div className="col-sm-6 col-xs-6">
                <div className="link main-menu">
                  MAIN MENU
                </div>
              </div>
              <div className="col-sm-6 col-xs-6">
                <div className="row gutters-xs">
                  <div className="col-sm-5 col-xs-5 col-sm-offset-1 col-xs-offset-1">
                    <div className="link prev">
                      PREV
                    </div>
                  </div>
                  <div className="col-sm-6 col-xs-6">
                    <div className="link next">
                      NEXT
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="jam-details">
            <div className="row gutters-xs">
              <div className="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
                <div className="jam-number">
                  <strong>Jam 5</strong>
                </div>
              </div>
              <div className="col-sm-3 col-xs-3 text-right">
                <div className="jam-total-score">
                  <strong>0</strong>
                </div>
              </div>
            </div>
          </div>
          <PassesList />
        </div>
      </div>
    </div>`


exports.PassesList = React.createClass
  render: () ->
    `<div className="passes">
      <div className="headers">
        <div className="row gutters-xs">
          <div className="col-sm-2 col-xs-2">
            Pass
          </div>
          <div className="col-sm-2 col-xs-2">
            Skater
          </div>
          <div className="col-sm-2 col-xs-2"></div>
          <div className="col-sm-2 col-xs-2 text-center">
            Notes
          </div>
          <div className="col-sm-2 col-xs-2"></div>
          <div className="col-sm-2 col-xs-2 text-center">
            Points
          </div>
        </div>
      </div>
      <div aria-multiselectable="true" id="home-team-pass-1">
        <div className="columns">
          <div className="row gutters-xs">
            <div className="col-sm-2 col-xs-2">
              <div aria-controls="#home-team-edit-pass-number-1" aria-expanded="false" className="pass text-center" data-parent="#home-team-pass-1" data-toggle="collapse" href="#home-team-edit-pass-number-1">
                1
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater">
                1234
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="notes injury text-center">
                Injury
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="notes call text-center">
                Call
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="notes lost text-center">
                Lost
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div aria-controls="#home-team-edit-pass-1" aria-expanded="false" className="points text-center" data-parent="#home-team-pass-1" data-toggle="collapse" href="#home-team-edit-pass-1">
                10
              </div>
            </div>
          </div>
        </div>
        <div className="panel">
          <div className="edit-pass-number collapse" id="home-team-edit-pass-number-1">
            <div className="row gutters-xs">
              <div className="col-sm-1 col-xs-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="minus text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="plus text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="ok text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="panel">
          <div className="edit-pass first-pass collapse" id="home-team-edit-pass-1">
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes injury text-center">
                  Injury
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes note-lead text-center">
                  Lead
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes call text-center">
                  Call
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="ok text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                </div>
              </div>
            </div>
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-3 col-xs-offset-3">
                <div className="zero text-center">
                  0
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="one text-center">
                  1
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes no-pass text-center">
                  No P.
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div aria-multiselectable="true" id="home-team-pass-2">
        <div className="columns">
          <div className="row gutters-xs">
            <div className="col-sm-2 col-xs-2">
              <div aria-controls="#home-team-edit-pass-number-2" aria-expanded="false" className="pass text-center" data-parent="#home-team-pass-2" data-toggle="collapse" href="#home-team-edit-pass-number-2">
                1
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="skater">
                1234
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="notes injury text-center">
                Injury
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="notes call text-center">
                Call
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div className="notes lost text-center">
                Lost
              </div>
            </div>
            <div className="col-sm-2 col-xs-2">
              <div aria-controls="#home-team-edit-pass-2" aria-expanded="false" className="points text-center" data-parent="#home-team-pass-2" data-toggle="collapse" href="#home-team-edit-pass-2">
                5
              </div>
            </div>
          </div>
        </div>
        <div className="panel">
          <div className="edit-pass-number collapse" id="home-team-edit-pass-number-2">
            <div className="row gutters-xs">
              <div className="col-sm-1 col-xs-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="minus text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-minus"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="plus text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-plus"></span>
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="ok text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className="panel">
          <div className="edit-pass second-pass collapse" id="home-team-edit-pass-2">
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                <div className="remove text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-remove"></span>
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes injury text-center">
                  Injury
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes note-lead text-center">
                  Lead
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="notes call text-center">
                  Call
                </div>
              </div>
              <div className="col-sm-2 col-xs-2">
                <div className="ok text-center">
                  <span aria-hidden="true" className="glyphicon glyphicon-ok"></span>
                </div>
              </div>
            </div>
            <div className="row gutters-xs">
              <div className="col-sm-1 col-xs-1 col-sm-offset-2 col-xs-offset-2">
                <div className="zero text-center">
                  0
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="one text-center">
                  1
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="two text-center">
                  2
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="three text-center">
                  3
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="four text-center">
                  4
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="five text-center">
                  5
                </div>
              </div>
              <div className="col-sm-1 col-xs-1">
                <div className="six text-center">
                  6
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>`

# exports.PassItem = React.createClass
