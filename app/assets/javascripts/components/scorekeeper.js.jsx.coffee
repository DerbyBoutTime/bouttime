exports = exports ? this
exports.Scorekeeper = React.createClass
  getInitialState: () ->
    null
  render: () ->

    `<div id="scorekeeper-view">
      <div class="row teams text-center gutters-xs">
        <div class="col-sm-6 col-xs-6">
          <div class="team-name away">
            Atlanta Rollergirls
          </div>
        </div>
        <div class="col-sm-6 col-xs-6">
          <div class="team-name home">
            Gotham Rollergirls
          </div>
        </div>
      </div>
      <div class="active-team">
        <div class="row gutters-xs">
          <div class="col-sm-6 col-xs-6">
            <div class="away"></div>
          </div>
          <div class="col-sm-6 col-xs-6">
            <div class="home hidden-xs"></div>
          </div>
        </div>
      </div>
      <div class="row gutters-xs">
        <div class="col-sm-6 col-xs-12" id="away-team">
          <div class="row stats gutters-xs">
            <div class="col-sm-6 col-xs-6">
              <div class="stat current-jam">
                <div class="row gutters-xs">
                  <div class="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Current Jam</strong>
                  </div>
                  <div class="col-sm-2 col-xs-2 text-right current-jam-score">
                    <strong>0</strong>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-sm-6 col-xs-6">
              <div class="stat game-total">
                <div class="row gutters-xs">
                  <div class="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Game Total</strong>
                  </div>
                  <div class="col-sm-2 col-xs-2 text-right game-total-score">
                    <strong>0</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="jams">
            <div class="headers">
              <div class="row gutters-xs">
                <div class="col-sm-2 col-xs-2">
                  <strong>Jam</strong>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <strong>Skater</strong>
                </div>
                <div class="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Notes</strong>
                </div>
                <div class="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Points</strong>
                </div>
              </div>
            </div>
            <div class="columns">
              <div class="row gutters-xs">
                <div class="col-sm-2 col-xs-2">
                  <div class="jam text-center">
                    1
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="skater">
                    4567
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="notes injury text-center">
                    Injury
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="notes call text-center">
                    Call
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="notes lost text-center">
                    Lost
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="points text-center">
                    10
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="links">
            <div class="row text-center gutters-xs">
              <div class="col-sm-6 col-xs-6">
                <div class="link main-menu">
                  MAIN MENU
                </div>
              </div>
              <div class="col-sm-6 col-xs-6">
                <div class="row gutters-xs">
                  <div class="col-sm-5 col-xs-5 col-sm-offset-1 col-xs-offset-1">
                    <div class="link prev">
                      PREV
                    </div>
                  </div>
                  <div class="col-sm-6 col-xs-6">
                    <div class="link next">
                      NEXT
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="jam-details">
            <div class="row gutters-xs">
              <div class="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
                <div class="jam-number">
                  <strong>Jam 5</strong>
                </div>
              </div>
              <div class="col-sm-3 col-xs-3 text-right">
                <div class="jam-total-score">
                  <strong>0</strong>
                </div>
              </div>
            </div>
          </div>
          <div class="passes">
            <div class="headers">
              <div class="row gutters-xs">
                <div class="col-sm-2 col-xs-2">
                  Pass
                </div>
                <div class="col-sm-2 col-xs-2">
                  Skater
                </div>
                <div class="col-sm-2 col-xs-2"></div>
                <div class="col-sm-2 col-xs-2 text-center">
                  Notes
                </div>
                <div class="col-sm-2 col-xs-2"></div>
                <div class="col-sm-2 col-xs-2 text-center">
                  Points
                </div>
              </div>
            </div>
            <div aria-multiselectable="true" id="away-team-pass-1">
              <div class="columns">
                <div class="row gutters-xs">
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-number-1" aria-expanded="false" class="pass text-center" data-parent="#away-team-pass-1" data-toggle="collapse" href="#away-team-edit-pass-number-1">
                      1
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="skater">
                      1234
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes injury text-center">
                      Injury
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes call text-center">
                      Call
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes lost text-center">
                      Lost
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-1" aria-expanded="false" class="points text-center" data-parent="#away-team-pass-1" data-toggle="collapse" href="#away-team-edit-pass-1">
                      10
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass-number collapse" id="away-team-edit-pass-number-1">
                  <div class="row gutters-xs">
                    <div class="col-sm-1 col-xs-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="minus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-minus"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="plus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-plus"></span>
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass first-pass collapse" id="away-team-edit-pass-1">
                  <div class="row gutters-xs">
                    <div class="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes injury text-center">
                        Injury
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes note-lead text-center">
                        Lead
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes call text-center">
                        Call
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                  <div class="row gutters-xs">
                    <div class="col-sm-2 col-xs-2 col-sm-offset-3 col-xs-offset-3">
                      <div class="zero text-center">
                        0
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="one text-center">
                        1
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes no-pass text-center">
                        No P.
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div aria-multiselectable="true" id="away-team-pass-2">
              <div class="columns">
                <div class="row gutters-xs">
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-number-2" aria-expanded="false" class="pass text-center" data-parent="#away-team-pass-2" data-toggle="collapse" href="#away-team-edit-pass-number-2">
                      1
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="skater">
                      1234
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes injury text-center">
                      Injury
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes call text-center">
                      Call
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes lost text-center">
                      Lost
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#away-team-edit-pass-2" aria-expanded="false" class="points text-center" data-parent="#away-team-pass-2" data-toggle="collapse" href="#away-team-edit-pass-2">
                      5
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass-number collapse" id="away-team-edit-pass-number-2">
                  <div class="row gutters-xs">
                    <div class="col-sm-1 col-xs-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="minus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-minus"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="plus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-plus"></span>
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass second-pass collapse" id="away-team-edit-pass-2">
                  <div class="row gutters-xs">
                    <div class="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes injury text-center">
                        Injury
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes note-lead text-center">
                        Lead
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes call text-center">
                        Call
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                  <div class="row gutters-xs">
                    <div class="col-sm-1 col-xs-1 col-sm-offset-2 col-xs-offset-2">
                      <div class="zero text-center">
                        0
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="one text-center">
                        1
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="two text-center">
                        2
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="three text-center">
                        3
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="four text-center">
                        4
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="five text-center">
                        5
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="six text-center">
                        6
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-sm-6 col-xs-12 hidden-xs" id="home-team">
          <div class="row stats gutters-xs">
            <div class="col-sm-6 col-xs-6">
              <div class="stat current-jam">
                <div class="row gutters-xs">
                  <div class="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Current Jam</strong>
                  </div>
                  <div class="col-sm-2 col-xs-2 text-right current-jam-score">
                    <strong>0</strong>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-sm-6 col-xs-6">
              <div class="stat game-total">
                <div class="row gutters-xs">
                  <div class="col-sm-8 col-xs-8 col-sm-offset-1 col-xs-offset-1">
                    <strong>Game Total</strong>
                  </div>
                  <div class="col-sm-2 col-xs-2 text-right game-total-score">
                    <strong>0</strong>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="jams">
            <div class="headers">
              <div class="row gutters-xs">
                <div class="col-sm-2 col-xs-2">
                  <strong>Jam</strong>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <strong>Skater</strong>
                </div>
                <div class="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Notes</strong>
                </div>
                <div class="col-sm-2 col-xs-2 col-sm-offset-2 col-xs-offset-2 text-center">
                  <strong>Points</strong>
                </div>
              </div>
            </div>
            <div class="columns">
              <div class="row gutters-xs">
                <div class="col-sm-2 col-xs-2">
                  <div class="jam text-center">
                    1
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="skater">
                    1234
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="notes injury text-center">
                    Injury
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="notes call text-center">
                    Call
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="notes lost text-center">
                    Lost
                  </div>
                </div>
                <div class="col-sm-2 col-xs-2">
                  <div class="points text-center">
                    10
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="links">
            <div class="row text-center gutters-xs">
              <div class="col-sm-6 col-xs-6">
                <div class="link main-menu">
                  MAIN MENU
                </div>
              </div>
              <div class="col-sm-6 col-xs-6">
                <div class="row gutters-xs">
                  <div class="col-sm-5 col-xs-5 col-sm-offset-1 col-xs-offset-1">
                    <div class="link prev">
                      PREV
                    </div>
                  </div>
                  <div class="col-sm-6 col-xs-6">
                    <div class="link next">
                      NEXT
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="jam-details">
            <div class="row gutters-xs">
              <div class="col-sm-3 col-xs-3 col-sm-offset-6 col-xs-offset-6">
                <div class="jam-number">
                  <strong>Jam 5</strong>
                </div>
              </div>
              <div class="col-sm-3 col-xs-3 text-right">
                <div class="jam-total-score">
                  <strong>0</strong>
                </div>
              </div>
            </div>
          </div>
          <div class="passes">
            <div class="headers">
              <div class="row gutters-xs">
                <div class="col-sm-2 col-xs-2">
                  Pass
                </div>
                <div class="col-sm-2 col-xs-2">
                  Skater
                </div>
                <div class="col-sm-2 col-xs-2"></div>
                <div class="col-sm-2 col-xs-2 text-center">
                  Notes
                </div>
                <div class="col-sm-2 col-xs-2"></div>
                <div class="col-sm-2 col-xs-2 text-center">
                  Points
                </div>
              </div>
            </div>
            <div aria-multiselectable="true" id="home-team-pass-1">
              <div class="columns">
                <div class="row gutters-xs">
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#home-team-edit-pass-number-1" aria-expanded="false" class="pass text-center" data-parent="#home-team-pass-1" data-toggle="collapse" href="#home-team-edit-pass-number-1">
                      1
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="skater">
                      1234
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes injury text-center">
                      Injury
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes call text-center">
                      Call
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes lost text-center">
                      Lost
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#home-team-edit-pass-1" aria-expanded="false" class="points text-center" data-parent="#home-team-pass-1" data-toggle="collapse" href="#home-team-edit-pass-1">
                      10
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass-number collapse" id="home-team-edit-pass-number-1">
                  <div class="row gutters-xs">
                    <div class="col-sm-1 col-xs-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="minus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-minus"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="plus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-plus"></span>
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass first-pass collapse" id="home-team-edit-pass-1">
                  <div class="row gutters-xs">
                    <div class="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes injury text-center">
                        Injury
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes note-lead text-center">
                        Lead
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes call text-center">
                        Call
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                  <div class="row gutters-xs">
                    <div class="col-sm-2 col-xs-2 col-sm-offset-3 col-xs-offset-3">
                      <div class="zero text-center">
                        0
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="one text-center">
                        1
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes no-pass text-center">
                        No P.
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div aria-multiselectable="true" id="home-team-pass-2">
              <div class="columns">
                <div class="row gutters-xs">
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#home-team-edit-pass-number-2" aria-expanded="false" class="pass text-center" data-parent="#home-team-pass-2" data-toggle="collapse" href="#home-team-edit-pass-number-2">
                      1
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="skater">
                      1234
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes injury text-center">
                      Injury
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes call text-center">
                      Call
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div class="notes lost text-center">
                      Lost
                    </div>
                  </div>
                  <div class="col-sm-2 col-xs-2">
                    <div aria-controls="#home-team-edit-pass-2" aria-expanded="false" class="points text-center" data-parent="#home-team-pass-2" data-toggle="collapse" href="#home-team-edit-pass-2">
                      5
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass-number collapse" id="home-team-edit-pass-number-2">
                  <div class="row gutters-xs">
                    <div class="col-sm-1 col-xs-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="minus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-minus"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="plus text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-plus"></span>
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel">
                <div class="edit-pass second-pass collapse" id="home-team-edit-pass-2">
                  <div class="row gutters-xs">
                    <div class="col-sm-2 col-xs-2 col-sm-offset-1 col-xs-offset-1">
                      <div class="remove text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-remove"></span>
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes injury text-center">
                        Injury
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes note-lead text-center">
                        Lead
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="notes call text-center">
                        Call
                      </div>
                    </div>
                    <div class="col-sm-2 col-xs-2">
                      <div class="ok text-center">
                        <span aria-hidden="true" class="glyphicon glyphicon-ok"></span>
                      </div>
                    </div>
                  </div>
                  <div class="row gutters-xs">
                    <div class="col-sm-1 col-xs-1 col-sm-offset-2 col-xs-offset-2">
                      <div class="zero text-center">
                        0
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="one text-center">
                        1
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="two text-center">
                        2
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="three text-center">
                        3
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="four text-center">
                        4
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="five text-center">
                        5
                      </div>
                    </div>
                    <div class="col-sm-1 col-xs-1">
                      <div class="six text-center">
                        6
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>`
