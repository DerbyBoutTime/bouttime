exports = exports ? window
QUnit.module "Scoreboard",
  setup: () ->
    exports.scoreboard = new wftda.classes.Scoreboard()
    exports.scoreboard.initialize()
  teardown: () ->
QUnit.test "Should receive heartbeat", (assert) ->
  timestamp = Date.now()
  exports.scoreboard.receiveHeartbeat
    timestamp: timestamp
  assert.ok exports.scoreboard.lastHeartbeat == timestamp
QUnit.test "Should set home team name", (assert) ->
  expect 1
  exports.scoreboard.setHomeTeamName("foo")
  assert.ok scoreboard.home.name == "foo"
QUnit.test "Should set away team name", (assert) ->
  exports.scoreboard.setAwayTeamName("foo")
  assert.ok exports.scoreboard.away.name == "foo"
QUnit.test "Should set home team logo URL", (assert) ->
  exports.scoreboard.setHomeTeamLogo("//placehold.it/250x250")
  assert.ok exports.scoreboard.home.logoUrl == "//placehold.it/250x250"
QUnit.test "Should set away team logo URL", (assert) ->
  exports.scoreboard.setAwayTeamLogo("//placehold.it/250x250")
  assert.ok exports.scoreboard.away.logoUrl == "//placehold.it/250x250"
QUnit.test "Should increment jam number", (assert) ->
  jam = exports.scoreboard.jam
  exports.scoreboard.incrementJamNumber()
  assert.ok exports.scoreboard.jam == jam + 1
QUnit.test "Should decrement jam number", (assert) ->
  jam = exports.scoreboard.jam
  exports.scoreboard.decrementJamNumber()
  assert.ok exports.scoreboard.jam == jam - 1
QUnit.test "Should increment period number", (assert) ->
  period = exports.scoreboard.period
  exports.scoreboard.incrementPeriodNumber()
  assert.ok exports.scoreboard.period == period + 1
QUnit.test "Should decrement period number", (assert) ->
  period = exports.scoreboard.period
  exports.scoreboard.decrementPeriodNumber()
  assert.ok exports.scoreboard.period == period - 1
QUnit.test "Should increment home team score", (assert) ->
  start = exports.scoreboard.home.score
  exports.scoreboard.incrementHomeTeamScore()
  assert.ok exports.scoreboard.home.score == start + 1
QUnit.test "Should decrement home team score", (assert) ->
  start = exports.scoreboard.home.score
  exports.scoreboard.decrementHomeTeamScore()
  assert.ok exports.scoreboard.home.score == start - 1
QUnit.test "Should increment away team score", (assert) ->
  start = exports.scoreboard.away.score
  exports.scoreboard.incrementAwayTeamScore()
  assert.ok exports.scoreboard.away.score == start + 1
QUnit.test "Should decrement away team score", (assert) ->
  start = exports.scoreboard.away.score
  exports.scoreboard.decrementAwayTeamScore()
  assert.ok exports.scoreboard.away.score == start - 1
QUnit.test "Should increment home team jam points", (assert) ->
  start = exports.scoreboard.home.jamPoints
  exports.scoreboard.incrementHomeTeamScore()
  assert.ok exports.scoreboard.home.jamPoints == start + 1
QUnit.test "Should increment away team jam points", (assert) ->
  start = exports.scoreboard.away.jamPoints
  exports.scoreboard.incrementAwayTeamScore()
  assert.ok exports.scoreboard.away.jamPoints == start + 1
QUnit.test "Should decrement home team jam points", (assert) ->
  start = exports.scoreboard.home.jamPoints
  exports.scoreboard.decrementHomeTeamScore()
  assert.ok exports.scoreboard.home.jamPoints == start - 1
QUnit.test "Should decrement away team jam points", (assert) ->
  start = exports.scoreboard.away.jamPoints
  exports.scoreboard.decrementAwayTeamScore()
  assert.ok exports.scoreboard.away.jamPoints == start - 1
QUnit.test "Should stop clocks on timeout", (assert) ->
  assert.expect 2
  periodClockStart = exports.scoreboard.periodClock
  jamClockStart = exports.scoreboard.jamClock
  exports.scoreboard.startTimeout()
  assert.ok periodClockStart == exports.scoreboard.periodClock
  assert.ok jamClockStart == exports.scoreboard.jamClock
QUnit.test "Should assign timeout to home team", (assert) ->
  expect 6
  timeouts = exports.scoreboard.home.timeouts
  exports.scoreboard.assignTimeoutToHomeTeam()
  assert.ok exports.scoreboard.home.timeouts == timeouts - 1
  assert.ok exports.scoreboard.home.isTakingTimeout
  assert.ok exports.scoreboard.inTimeout == true
  exports.scoreboard.undo()
  assert.ok exports.scoreboard.home.timeouts == timeouts
  assert.ok exports.scoreboard.home.isTakingTimeout == false
  assert.ok exports.scoreboard.inTimeout == false
QUnit.test "Should assign timeout to away team", (assert) ->
  expect 6
  timeouts = exports.scoreboard.away.timeouts
  exports.scoreboard.assignTimeoutToAwayTeam()
  assert.ok exports.scoreboard.away.timeouts == timeouts - 1
  assert.ok exports.scoreboard.away.isTakingTimeout
  assert.ok exports.scoreboard.inTimeout
  exports.scoreboard.undo()
  assert.ok exports.scoreboard.away.timeouts == timeouts
  assert.ok exports.scoreboard.away.isTakingTimeout == false
  assert.ok exports.scoreboard.inTimeout == false
QUnit.test "Should assign timeout to officials", (assert) ->
  expect 1
  exports.scoreboard.assignTimeoutToOfficials()
  assert.ok exports.scoreboard.inTimeout
QUnit.test "Official Timeout should stop the clocks", (assert) ->
  expect 2
  periodClockStart = exports.scoreboard.periodClock
  jamClockStart = exports.scoreboard.jamClock
  exports.scoreboard.assignTimeoutToOfficials()
  assert.ok periodClockStart == exports.scoreboard.periodClock
  assert.ok jamClockStart == exports.scoreboard.jamClock
QUnit.test "Should assign official review to home team", (assert) ->
  expect 6
  exports.scoreboard.assignTimeoutToHomeTeamOfficialReview()
  assert.ok exports.scoreboard.home.hasOfficialReview == false
  assert.ok exports.scoreboard.home.isTakingOfficialReview == true
  assert.ok exports.scoreboard.inTimeout
  exports.scoreboard.undo()
  assert.ok exports.scoreboard.home.hasOfficialReview == true
  assert.ok exports.scoreboard.home.isTakingOfficialReview == false
  assert.ok exports.scoreboard.inTimeout == false
QUnit.test "Should assign official review to away team", (assert) ->
  expect 6
  exports.scoreboard.assignTimeoutToAwayTeamOfficialReview()
  assert.ok exports.scoreboard.away.hasOfficialReview == false
  assert.ok exports.scoreboard.away.isTakingOfficialReview == true
  assert.ok exports.scoreboard.inTimeout == true
  exports.scoreboard.undo()
  assert.ok exports.scoreboard.away.hasOfficialReview == true
  assert.ok exports.scoreboard.away.isTakingOfficialReview == false
  assert.ok exports.scoreboard.inTimeout == false
QUnit.asyncTest "On jam start, start period clock and jam clock", (assert) ->
  expect 2
  periodStart = exports.scoreboard.periodTime
  exports.scoreboard.startJam()
  exports.scoreboard.base.one "jamTick", (evt, data) ->
    assert.ok data.timestamp?
  exports.scoreboard.base.one "periodTick", (evt, data) ->
    assert.ok data.timestamp?
    QUnit.start()
QUnit.test "On jam start, should clear jam points", (assert) ->
  expect 4
  exports.scoreboard.incrementAwayTeamScore()
  exports.scoreboard.incrementHomeTeamScore()
  assert.ok exports.scoreboard.home.jamPoints == 1
  assert.ok exports.scoreboard.away.jamPoints == 1
  exports.scoreboard.startJam()
  assert.ok exports.scoreboard.home.jamPoints == 0
  assert.ok exports.scoreboard.away.jamPoints == 0
QUnit.test "On jam start, should increment jam number", (assert) ->
  jam = exports.scoreboard.jam
  exports.scoreboard.startJam()
  assert.ok exports.scoreboard.jam = jam + 1
QUnit.asyncTest "On jam stop, should stop period clock and should reset jam clock to lineup", (assert) ->
  expect 2
  exports.scoreboard.startJam()
  exports.scoreboard.base.one "jamTick", (evt, data) ->
    exports.scoreboard.stopJam()
    exports.scoreboard.base.one "jamTick", (evt, data) ->
      assert.ok exports.scoreboard.jamTime > exports.wftda.constants.LINEUP_DURATION_IN_MS - 1000
      assert.ok exports.scoreboard.isPeriodClockRunning() == false
      QUnit.start()
QUnit.test "Should set unofficial final", (assert) ->
  exports.scoreboard.setUnofficialFinal()
  assert.ok exports.scoreboard.inUnofficialFinal == true
QUnit.test "Should set official final", (assert) ->
  expect 2
  exports.scoreboard.setUnofficialFinal()
  exports.scoreboard.setOfficialFinal()
  assert.ok exports.scoreboard.inOfficialFinal == true
  assert.ok exports.scoreboard.inUnofficialFinal == false
QUnit.test "Should fly-in stat", (assert) ->
  assert.ok false
QUnit.test "Should rotate ads", (assert) ->
  assert.ok false
QUnit.test "Should set time to derby", (assert) ->
  exports.scoreboard.setTimeToDerby(1000*60*30)
  assert.ok exports.scoreboard.jamTime == 1000*60*30
QUnit.asyncTest "Should send period clock tick", (assert) ->
  expect 2
  exports.scoreboard.startJam()
  exports.scoreboard.base.one "periodTick", (evt, data) ->
    assert.ok data.timestamp?
    assert.ok data.displayTime?
    QUnit.start()
QUnit.asyncTest "Should send jam clock tick", (assert) ->
  expect 3
  exports.scoreboard.startJam()
  exports.scoreboard.base.one "jamTick", (evt, data) ->
    assert.ok data.timestamp?
    assert.ok data.displayTime?
    assert.ok data.displayLabel?
    QUnit.start()
QUnit.test "Should set home team jammer name", (assert) ->
  exports.scoreboard.setHomeTeamJammer("foo")
  assert.ok exports.scoreboard.home.jammer.name == "foo"
QUnit.test "Should set away team jammer name", (assert) ->
  exports.scoreboard.setHomeTeamJammer("bar")
  assert.ok exports.scoreboard.home.jammer.name == "bar"
QUnit.test "Should set home team jammer lead then not lead", (assert) ->
  exports.scoreboard.setHomeTeamLead()
  assert.ok exports.scoreboard.home.jammer.lead == true
  exports.scoreboard.setHomeTeamNotLead()
  assert.ok exports.scoreboard.home.jammer.lead == false
QUnit.test "Should set away team jammer lead then not lead", (assert) ->
  exports.scoreboard.setAwayTeamLead()
  assert.ok exports.scoreboard.away.jammer.lead == true
  assert.ok exports.scoreboard.home.jammer.lead == false
  exports.scoreboard.setHomeTeamNotLead()