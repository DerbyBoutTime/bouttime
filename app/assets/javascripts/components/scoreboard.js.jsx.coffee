# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
exports = exports ? this
exports.Scoreboard = React.createClass
  setInitialState: () ->
    jamNumber: 1
    periodNumber: 1
    jamClock: "00:00"
    periodClock: "00:00"
    team:
      home:
        points: 0
      away:
        points: 0
  render: () ->
    `<div class="scoreboard" id="scoreboard">
      <section class="team">
        <div class="logo">
          <img src="{this.prop.logoURI}" />
        </div>
        <div class="name">{this.state.teamName}</div>
        <div class="color-bar" style="background-color:{this.state.color}"></div>
        <div class="score">{this.state.score}</div>
        <div class="jammer">
          <div class="lead-status">
            <span class="glyphicon glyphicon-star {this.state.jammer.lead ? '' : 'hidden'}"></span>
          </div>
          <div class="name">{this.state.jammer.name}</div>
        </div>
        <div class="timeouts">
          <div class="timeout-bar official-review {this.state.hasOfficialReview ? :}"></div>
          <div class="timeout-bar timeout"></div>
          <div class="timeout-bar timeout"></div>
          <div class="timeout-bar timeout"></div>
        </div>
      </section>
      <section class="clocks">
        <div class="clocks-border">
          <div class="period-jam-counts">
            <div class="period">
              <label class="hidden-xs hidden-sm">Period</label>
              <label class="visible-sm-block">Per</label>
              <div class="number period-number"></div>
            </div>
            <div class="jam">
              <label>Jam</label>
              <div class="number jam-number"></div>
            </div>
          </div>
          <div class="period-clock"
            <label class="hidden">Period Clock</label>
            <div class="clock period-clock"></div>
          </div>
          <div class="jam-clock">
            <label class="jam-clock-label">Time to Derby</label>
            <div class="clock"></div>
          </div>
        </div>
        <div class="jam-points-wrapper">
          <div class="home-team-jam-points points"></div>
          <div class="away-team-jam-points points"></div>
        </div>
      </section>
      <section class="team">
        <div class="logo">
          <img src="{this.prop.logoURI}" />
        </div>
        <div class="name">{this.state.teamName}</div>
        <div class="color-bar" style="background-color:{this.state.color}"></div>
        <div class="score">{this.state.score}</div>
        <div class="jammer">
          <div class="lead-status">
            <span class="glyphicon glyphicon-star {this.state.jammer.lead ? '' : 'hidden'}"></span>
          <div class="name">{this.state.jammer.name}</div>
        </div>
        <div class="timeouts">
          <div class="timeout-bar official-review {this.state.hasOfficialReview ? :}"></div>
          <div class="timeout-bar timeout"></div>
          <div class="timeout-bar timeout"></div>
          <div class="timeout-bar timeout"></div>
        </div>
      </section>
      <section class="alerts">
        <div class="alert-home">
          <div class="scoreboard-alert home-team-timeout hidden">timeout</div>
            <div class="scoreboard-alert home-team-official-review hidden">official review</div>
            <div class="scoreboard-alert home-team-unofficial-final hidden">unofficial final</div>
            <div class="scoreboard-alert home-team-final hidden">final</div>
          </div>
          <div class="alert-away">
            <div class="scoreboard-alert away-team-timeout hidden">timeout</div>
            <div class="scoreboard-alert away-team-official-review hidden">official review</div>
            <div class="scoreboard-alert away-team-unofficial-final hidden">final</div>
            <div class="scoreboard-alert away-team-final hidden">final</div>
          </div>
          <div class="alert-neutral">
            <div class="scoreboard-alert generic-timeout hidden">timeout</div>
            <div class="scoreboard-alert official-timeout hidden">official timeout</div>
            <div class="scoreboard-alert unofficial-final hidden">unofficial final</div>
            <div class="scoreboard-alert official-final hidden">final</div>
          </div>
        </div>
      </section>
      <section class="ads"></section>
      <section class="fly-ins"></section>
    </div>`
exports.Scoreboard = Scoreboard
