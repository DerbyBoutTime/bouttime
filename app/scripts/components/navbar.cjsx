React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  render: () ->
    jamTimerCS = cx
      'active': @props.tab == "jam_timer"
    lineupTrackerCS = cx
      'active': @props.tab == "lineup_tracker"
    scorekeeperCS = cx
      'active': @props.tab == "scorekeeper"
    penaltyTrackerCS = cx
      'active': @props.tab == "penalty_tracker"
    penaltyBoxTimerCS = cx
      'active': @props.tab == "penalty_box_timer"
    scoreboardCS = cx
      'active': @props.tab == "scoreboard"
    penaltyWhiteboardCS = cx
      'active': @props.tab == "penalty_whiteboard"
    announcersFeedCS = cx
      'active': @props.tab == "announcers_feed"
    <div className="navbar">
      <div className="container">
        <div className="row">
          <div className="col-xs-12 col-sm-12">
            <ul className="nav navbar-nav">
              <li className={jamTimerCS} onClick={@props.tabHandler.bind(null, "jam_timer")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/jam-timer.svg" width="48"/>
                  <img className="visible-xs-block img-responsive" src="/images/icons/jam-timer.svg" width="32"/>
                </a>
              </li>
              <li className={lineupTrackerCS} onClick={@props.tabHandler.bind(null, "lineup_tracker")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/lineup-tracker.svg" width="48" />
                  <img className="visible-xs-block" src="/images/icons/lineup-tracker.svg" width="32"/>
                </a>
              </li>
              <li className={scorekeeperCS} onClick={@props.tabHandler.bind(null, "scorekeeper")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/scorekeeper.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/scorekeeper.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyTrackerCS} onClick={@props.tabHandler.bind(null, "penalty_tracker")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/penalty-tracker.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/penalty-tracker.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyBoxTimerCS} onClick={@props.tabHandler.bind(null, "penalty_box_timer")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/penalty-box.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/penalty-box.svg" width="32"/>
                </a>
              </li>
              <li className={scoreboardCS} onClick={@props.tabHandler.bind(null, "scoreboard")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/scoreboard.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/scoreboard.svg" width="32"/>
                </a>
              </li>
              <li className={penaltyWhiteboardCS} onClick={@props.tabHandler.bind(null, "penalty_whiteboard")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/whiteboard.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/whiteboard.svg" width="32"/>
                </a>
              </li>
              <li className={announcersFeedCS} onClick={@props.tabHandler.bind(null, "announcers_feed")}>
                <a>
                  <img className="hidden-xs" src="/images/icons/announcers-feed.svg" width="48"/>
                  <img className="visible-xs-block" src="/images/icons/announcers-feed.svg" width="32"/>
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
