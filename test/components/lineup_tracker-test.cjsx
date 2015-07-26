React = require 'react/addons'
LineupTracker = require '../../app/scripts/components/lineup_tracker'
TeamSelector = require '../../app/scripts/components/shared/team_selector'
LineupSelector = require '../../app/scripts/components/lineup_tracker/lineup_selector'
TeamLineup = require '../../app/scripts/components/lineup_tracker/team_lineup'
TestUtils = React.addons.TestUtils
DemoData = require '../../app/scripts/demo_data'
Promise = require 'bluebird'
describe 'LineupTracker', () ->
  gameState = null
  setSelectorContext = (team, jam, func) ->
    [team, jam, func]
  lineupTracker = null
  beforeEach () ->
    gameState = DemoData.init()
    lineupTracker = gameState.then (gameState) ->
      shallowRenderer = TestUtils.createRenderer()
      shallowRenderer.render <LineupTracker gameState={gameState} setSelectorContext={setSelectorContext} /> 
      shallowRenderer.getRenderOutput()
  pit 'renders a component', () ->
    lineupTracker.then (lineupTracker) ->
      expect(TestUtils.isDOMComponent(lineupTracker))
  pit 'renders a team selector with team lineups', () ->
    Promise.join gameState, lineupTracker, (gameState, lineupTracker) ->
      teamSelector = lineupTracker.props.children[0]
      expect(TestUtils.isElementOfType(teamSelector, TeamSelector)).toBe(true)
      expect(TestUtils.isElementOfType(teamSelector.props.awayElement, TeamLineup)).toBe(true)
      expect(TestUtils.isElementOfType(teamSelector.props.homeElement, TeamLineup)).toBe(true)
      expect(teamSelector.props.awayElement.props.team).toBe(gameState.away)
      expect(teamSelector.props.homeElement.props.team).toBe(gameState.home)
  pit 'renders a lineup selector', () ->
    lineupTracker.then (lineupTracker) ->
      lineupSelector = lineupTracker.props.children[1]
      expect(TestUtils.isElementOfType(lineupSelector, LineupSelector)).toBe(true)
