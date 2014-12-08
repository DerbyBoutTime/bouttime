# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
cx = React.addons.classSet
exports = exports ? this
exports.Scoreboard = React.createClass
  getInitialState: () ->
    exports.wftda.functions.camelize(this.props)
  render: () ->
    `<div className="scoreboard" id="scoreboard">
      <section className="team home">
        <div className="logo">
          <img src={this.state.home.logoURI} />
        </div>
        <div className="name">{this.state.home.name}</div>
        <div className="color-bar" style={this.state.home.colorBarStyle}></div>
        <div className="score">{this.state.home.points}</div>
        <div className="jammer home-team-jammer">
          <div className="lead-status">
            <span className="glyphicon glyphicon-star" className={this.state.home.jammer.lead ? '' : 'hidden'}></span>
          </div>
          <div className="name">{this.state.home.jammer.name}</div>
        </div>
        <div className="timeouts home-team-timeouts">
          <div style={this.state.home.hasOfficialReview ? this.state.home.colorBarStyle : this.state.inactiveColorBarStyle} className="timeout-bar official-review"></div>
          <div style={this.state.home.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.state.home.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.state.home.colorBarStyle} className="timeout-bar timeout"></div>
        </div>
      </section>
      <section className="clocks">
        <div className="clocks-border">
          <div className="period-jam-counts">
            <div className="period">
              <label className="hidden-xs hidden-sm">Period</label>
              <label className="visible-sm-block">Per</label>
              <div className="number period-number">{this.state.periodNumber}</div>
            </div>
            <div className="jam">
              <label>Jam</label>
              <div className="number jam-number">{this.state.jamNumber}</div>
            </div>
          </div>
          <div className="period-clock">
            <label className="hidden">Period Clock</label>
            <div className="clock period-clock">{this.state.periodClock}</div>
          </div>
          <div className="jam-clock">
            <label className="jam-clock-label">{this.state.jamClockLabel}</label>
            <div className="clock">{this.state.jamClock}</div>
          </div>
        </div>
        <div className="jam-points-wrapper">
          <div className="home-team-jam-points points">{this.state.home.jamPoints}</div>
          <div className="away-team-jam-points points">{this.state.away.jamPoints}</div>
        </div>
      </section>
      <section className="team away">
        <div className="logo">
          <img src={this.state.away.logoURI} />
        </div>
        <div className="name">{this.state.away.name}</div>
        <div className="color-bar" style={this.state.away.colorBarStyle}></div>
        <div className="score">{this.state.away.points}</div>
        <div className="jammer away-team-jammer">
          <div className="lead-status">
            <span className="glyphicon glyphicon-star {this.state.away.jammer.lead ? '' : 'hidden'}"></span>
          </div>
          <div className="name">{this.state.away.jammer.name}</div>
        </div>
        <div className="timeouts away-team-timeouts">
          <div style={this.state.away.colorBarStyle} className="timeout-bar official-review {this.state.away.hasOfficialReview ? :}"></div>
          <div style={this.state.away.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.state.away.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.state.away.colorBarStyle} className="timeout-bar timeout"></div>
        </div>
      </section>
      <section className="alerts">
        <div className="alert-home">
          <div className="scoreboard-alert home-team-timeout hidden">timeout</div>
          <div className="scoreboard-alert home-team-official-review hidden">official review</div>
          <div className="scoreboard-alert home-team-unofficial-final hidden">unofficial final</div>
          <div className="scoreboard-alert home-team-final hidden">final</div>
        </div>
        <div className="alert-away">
          <div className="scoreboard-alert away-team-timeout hidden">timeout</div>
          <div className="scoreboard-alert away-team-official-review hidden">official review</div>
          <div className="scoreboard-alert away-team-unofficial-final hidden">final</div>
          <div className="scoreboard-alert away-team-final hidden">final</div>
        </div>
        <div className="alert-neutral">
          <div className="scoreboard-alert generic-timeout hidden">timeout</div>
          <div className="scoreboard-alert official-timeout hidden">official timeout</div>
          <div className="scoreboard-alert unofficial-final hidden">unofficial final</div>
          <div className="scoreboard-alert official-final hidden">final</div>
        </div>
      </section>
      <section className="ads"></section>
      <section className="fly-ins"></section>
    </div>`
