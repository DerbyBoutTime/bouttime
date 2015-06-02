React = require 'react/addons'
PenaltyTracker = require '../../app/scripts/components/penalty_tracker'
TeamSelector = require '../../app/scripts/components/shared/team_selector'
TeamPenalties = require '../../app/scripts/components/penalty_tracker/team_penalties'
TestUtils = React.addons.TestUtils
DemoData = require '../../app/scripts/demo_data'

describe 'PenaltyTracker', () ->
  gameState = null
  setSelectorContext = (team, jam, func) ->
    [team, jam, func]
  penaltyTracker = null
  beforeEach () ->
    gameState = DemoData.init()
    shallowRenderer = TestUtils.createRenderer()
    shallowRenderer.render <PenaltyTracker gameState={gameState} setSelectorContext={setSelectorContext} /> 
    penaltyTracker = shallowRenderer.getRenderOutput()
  it 'renders a component', () ->
    expect(TestUtils.isDOMComponent(penaltyTracker))
  it 'renders a team selector with team penalties', () ->
    teamSelector = penaltyTracker.props.children
    expect(TestUtils.isElementOfType(teamSelector, TeamSelector)).toBe(true)
    expect(TestUtils.isElementOfType(teamSelector.props.awayElement, TeamPenalties)).toBe(true)
    expect(TestUtils.isElementOfType(teamSelector.props.homeElement, TeamPenalties)).toBe(true)
    expect(teamSelector.props.awayElement.props.team).toBe(gameState.away)
    expect(teamSelector.props.homeElement.props.team).toBe(gameState.home)
