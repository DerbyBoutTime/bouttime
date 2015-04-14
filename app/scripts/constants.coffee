keyMirror = require 'keymirror'
module.exports =
  WEBSOCKETS_RETRY_TIME_IN_MS: 3000
  PERIOD_DURATION_IN_MS: 30*60*1000
  JAM_DURATION_IN_MS: 2*60*1000
  JAM_WARNING_IN_MS: 10*1000
  LINEUP_DURATION_IN_MS: 30*1000
  TIMEOUT_DURATION_IN_MS: 60*1000
  PENALTY_DURATION_IN_MS: 30*1000
  PENALTY_WARNING_IN_MS: 10*1000
  CLOCK_REFRESH_RATE_IN_MS: 500
  GAMES_STATES: ["pregame", "halftime", "jam", "lineup", "timeout", "unofficial_final", "final"]
  TIMEOUT_STATES: ["official_timeout", "home_team_timeout", "home_team_official_review", "away_team_timeout", "away_team_official_review"]
  HOUR_IN_MS: 3600000
  MINUTE_IN_MS: 60000
  SECOND_IN_MS: 1000
  ActionTypes: keyMirror
    TOGGLE_NO_PIVOT: null
    TOGGLE_STAR_PASS: null
    SET_SKATER_POSITION: null
    CYCLE_LINEUP_STATUS: null
    CREATE_NEXT_JAM: null
    TOGGLE_INJURY: null
    TOGGLE_NOPASS: null
    TOGGLE_CALLOFF: null
    TOGGLE_LOST_LEAD: null
    TOGGLE_LEAD: null
    SET_POINTS: null
    REORDER_PASS: null
    SET_PASS_JAMMER: null
    SET_PENALTY: null
    CLEAR_PENALTY: null
    UPDATE_PENALTY: null
    TOGGLE_LEFT_EARLY: null
    TOGGLE_PENALTY_SERVED: null
    SET_PENALTY_BOX_SKATER: null
