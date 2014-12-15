cx = React.addons.classSet
exports = exports ? this
exports.Navbar = React.createClass
  buildOptions: (opts = {}) ->
    std_opts =
      role: 'Global'
      timestamp: Date.now()
      state: this.state
    $.extend(std_opts, opts)
  componentDidMount: () ->
    $dom = $(this.getDOMNode())
    $dom.on 'click', 'ul.nav li', null, (evt) =>
      exports.dispatcher.trigger "global.change_tab", this.buildOptions
        tab: evt.currentTarget.dataset.tabName
  getInitialState: () ->
    this.props = exports.wftda.functions.camelize(this.props)
    state =
      tab: this.props.tab
  render: () ->
    jamTimerCS = cx
      'active': this.state.tab == "jam_timer"
    lineupTrackerCS = cx
      'active': this.state.tab == "lineup_tracker"
    scorekeeperCS = cx
      'active': this.state.tab == "scorekeeper"
    penaltyTrackerCS = cx
      'active': this.state.tab == "penalty_tracker"
    penaltyBoxTimerCS = cx
      'active': this.state.tab == "penalty_box_timer"
    `<div className="navbar">
      <div className="container">
        <div className="row">
          <div className="col-xs-12 col-sm-12">
            <ul className="nav navbar-nav">
              <li className={jamTimerCS} data-tab-name="jam_timer">
                <a href="#">
                  <img className="hidden-xs" src="/assets/icons/jam-timer.svg" width="48"/>
                  <img className="visible-xs-block img-responsive" src="/assets/icons/jam-timer.svg" width="32"/>
                </a>
              </li>
              <li className={lineupTrackerCS} data-tab-name="lineup_tracker">
                <a href="#">
                  <img className="hidden-xs" src="/assets/icons/lineup-tracker.svg" width="48" />
                  <img className="visible-xs-block" src="/assets/icons/lineup-tracker.svg" width="32"/>
                </a>
              </li>
              <li className={scorekeeperCS} data-tab-name="scorekeeper">
                <a href="#">
                  <img className="hidden-xs" src="/assets/icons/scorekeeper.svg" width="48"/>
                  <img className="visible-xs-block" src="/assets/icons/scorekeeper.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyTrackerCS} data-tab-name="penalty_tracker">
                <a href="#">
                  <img className="hidden-xs" src="/assets/icons/penalty-tracker.svg" width="48"/>
                  <img className="visible-xs-block" src="/assets/icons/penalty-tracker.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyBoxTimerCS} data-tab-name="penalty_box_timer">
                <a href="#">
                  <img className="hidden-xs" src="/assets/icons/penalty-box.svg" width="48"/>
                  <img className="visible-xs-block" src="/assets/icons/penalty-box.svg" width="32"/>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>`