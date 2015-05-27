React = require 'react/addons'
$ = require 'jquery'
cx = React.addons.classSet
module.exports = React.createClass
  buildOptions: (opts = {}) ->
    std_opts =
      role: 'Global'
      timestamp: Date.now()
      state: @state
    $.extend(std_opts, opts)
  componentDidMount: () ->
    $dom = $(@getDOMNode())
  getInitialState: () ->
    props = @props
    state =
      tab: props.tab
  componentWillReceiveProps: (props) ->
    @state.tab = props.tab
  render: () ->
    jamTimerCS = cx
      'active': @state.tab == "jam_timer"
    lineupTrackerCS = cx
      'active': @state.tab == "lineup_tracker"
    scorekeeperCS = cx
      'active': @state.tab == "scorekeeper"
    penaltyTrackerCS = cx
      'active': @state.tab == "penalty_tracker"
    penaltyBoxTimerCS = cx
      'active': @state.tab == "penalty_box_timer"
    scoreboardCS = cx
      'active': @state.tab == "scoreboard"
    penaltyWhiteboardCS = cx
      'active': @state.tab == "penalty_whiteboard"
    announcersFeedCS = cx
      'active': @state.tab == "announcers_feed"
    <div className="navbar">
      <div className="container">
        <div className="row">
          <div className="col-xs-12 col-sm-12">
            <ul className="nav navbar-nav">
              <li className={jamTimerCS} data-tab-name="jam_timer">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/jam-timer.svg" width="48"/>
                  <img className="visible-xs-block img-responsive" src="/images/icons/jam-timer.svg" width="32"/>
                </a>
              </li>
              <li className={lineupTrackerCS} data-tab-name="lineup_tracker">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/lineup-tracker.svg" width="48" />
                  <img className="visible-xs-block" src="/images/icons/lineup-tracker.svg" width="32"/>
                </a>
              </li>
              <li className={scorekeeperCS} data-tab-name="scorekeeper">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/scorekeeper.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/scorekeeper.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyTrackerCS} data-tab-name="penalty_tracker">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/penalty-tracker.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/penalty-tracker.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyBoxTimerCS} data-tab-name="penalty_box_timer">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/penalty-box.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/penalty-box.svg" width="32"/>
                </a>
              </li>
              <li className={scoreboardCS} data-tab-name="scoreboard">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/scoreboard.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/scoreboard.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyWhiteboardCS} data-tab-name="penalty_whiteboard">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/whiteboard.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/whiteboard.svg" width="32"/>
                </a>
              </li>
              <li className={announcersFeedCS} data-tab-name="announcers_feed">
                <a href="#">
                  <img className="hidden-xs" src="/images/icons/announcers-feed.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/announcers-feed.svg" width="32"/>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
