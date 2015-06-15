React = require 'react/addons'
LineupTracker = require '../../app/scripts/components/lineup_tracker'
TeamSelector = require '../../app/scripts/components/shared/team_selector'
LineupSelector = require '../../app/scripts/components/lineup_tracker/lineup_selector'
TeamLineup = require '../../app/scripts/components/lineup_tracker/team_lineup'
TestUtils = React.addons.TestUtils
DemoData = require '../../app/scripts/demo_data'

describe 'LineupTracker', () ->
  gameState = null
  setSelectorContext = (team, jam, func) ->
    [team, jam, func]
  lineupTracker = null
  beforeEach () ->
    gameState = DemoData.init()
    shallowRenderer = TestUtils.createRenderer()
    shallowRenderer.render <LineupTracker gameState={gameState} setSelectorContext={setSelectorContext} /> 
    lineupTracker = shallowRenderer.getRenderOutput()
  it 'renders a component', () ->
    expect(TestUtils.isDOMComponent(lineupTracker))
  it 'renders a team selector with team lineups', () ->
    teamSelector = lineupTracker.props.children[0]
    expect(TestUtils.isElementOfType(teamSelector, TeamSelector)).toBe(true)
    expect(TestUtils.isElementOfType(teamSelector.props.awayElement, TeamLineup)).toBe(true)
    expect(TestUtils.isElementOfType(teamSelector.props.homeElement, TeamLineup)).toBe(true)
    expect(teamSelector.props.awayElement.props.team).toBe(gameState.away)
    expect(teamSelector.props.homeElement.props.team).toBe(gameState.home)
  it 'renders a lineup selector', () ->
    lineupSelector = lineupTracker.props.children[1]
    expect(TestUtils.isElementOfType(lineupSelector, LineupSelector)).toBe(true)
