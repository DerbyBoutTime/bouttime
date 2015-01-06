# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
cx = React.addons.classSet
exports = exports ? this
exports.Scoreboard = React.createClass
  render: () ->
    console.log "Jam Time: #{this.props.jamClockAttributes.display}"
    `<div className="scoreboard" id="scoreboard">
      <section className="team home">
        <div className="logo">
          <img src={this.props.homeAttributes.logo} />
        </div>
        <div className="name">{this.props.homeAttributes.name}</div>
        <div className="color-bar" style={this.props.homeAttributes.colorBarStyle}></div>
        <div className="score">{this.props.homeAttributes.points}</div>
        <div className="jammer home-team-jammer">
          <div className="lead-status">
            <span className="glyphicon glyphicon-star" className={this.props.homeAttributes.jammerAttributes.lead ? '' : 'hidden'}></span>
          </div>
          <div className="name">{this.props.homeAttributes.jammerAttributes.number} {this.props.homeAttributes.jammerAttributes.name}</div>
        </div>
        <div className="timeouts home-team-timeouts">
          <div style={this.props.homeAttributes.hasOfficialReview ? this.props.homeAttributes.colorBarStyle : this.props.inactiveColorBarStyle} className="timeout-bar official-review"></div>
          <div style={this.props.homeAttributes.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.props.homeAttributes.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.props.homeAttributes.colorBarStyle} className="timeout-bar timeout"></div>
        </div>
      </section>
      <section className="clocks">
        <div className="clocks-border">
          <div className="period-jam-counts">
            <div className="period">
              <label className="hidden-xs hidden-sm">Period</label>
              <label className="visible-sm-block">Per</label>
              <div className="number period-number">{this.props.periodNumber}</div>
            </div>
            <div className="jam">
              <label>Jam</label>
              <div className="number jam-number">{this.props.jamNumber}</div>
            </div>
          </div>
          <div className="period-clock">
            <label className="hidden">Period Clock</label>
            <div className="clock period-clock">{this.props.periodClockAttributes.display}</div>
          </div>
          <div className="jam-clock">
            <label className="jam-clock-label">{this.props.state}</label>
            <div className="clock">{this.props.jamClockAttributes.display}</div>
          </div>
        </div>
        <div className="jam-points-wrapper">
          <div className="home-team-jam-points points">{this.props.homeAttributes.jamPoints}</div>
          <div className="away-team-jam-points points">{this.props.awayAttributes.jamPoints}</div>
        </div>
      </section>
      <section className="team away">
        <div className="logo">
          <img src={this.props.awayAttributes.logo} />
        </div>
        <div className="name">{this.props.awayAttributes.name}</div>
        <div className="color-bar" style={this.props.awayAttributes.colorBarStyle}></div>
        <div className="score">{this.props.awayAttributes.points}</div>
        <div className="jammer away-team-jammer">
          <div className="lead-status">
            <span className="glyphicon glyphicon-star {this.props.awayAttributes.jammerAttributes.lead ? '' : 'hidden'}"></span>
          </div>
          <div className="name">{this.props.awayAttributes.jammerAttributes.number} {this.props.awayAttributes.jammerAttributes.name}</div>
        </div>
        <div className="timeouts away-team-timeouts">
          <div style={this.props.awayAttributes.colorBarStyle} className="timeout-bar official-review {this.props.awayAttributes.hasOfficialReview ? :}"></div>
          <div style={this.props.awayAttributes.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.props.awayAttributes.colorBarStyle} className="timeout-bar timeout"></div>
          <div style={this.props.awayAttributes.colorBarStyle} className="timeout-bar timeout"></div>
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
