React = require 'react/addons'
Scorekeeper = require '../../app/scripts/components/scorekeeper'
TeamSelector = require '../../app/scripts/components/shared/team_selector'
JamsList = require '../../app/scripts/components/scorekeeper/jams_list'
TestUtils = React.addons.TestUtils
DemoData = require '../../app/scripts/demo_data'
Promise = require 'bluebird'
describe 'Scorekeeper', () ->
  gameState = null
  setSelectorContext = (team, jam, func) ->
    [team, jam, func]
  scorekeeper = null
  beforeEach () ->
    gameState = DemoData.init()
    scorekeeper = gameState.then (gameState) ->
      shallowRenderer = TestUtils.createRenderer()
      shallowRenderer.render <Scorekeeper gameState={gameState} setSelectorContext={setSelectorContext} /> 
      shallowRenderer.getRenderOutput()
  it 'renders a component', () ->
    scorekeeper.then (scorekeeper) ->
      expect(TestUtils.isDOMComponent(scorekeeper))
  it 'renders a team selector with jams lists', () ->
    Promise.join gameState, scorekeeper, (gameState, scorekeeper) ->
      teamSelector = scorekeeper.props.children
      expect(TestUtils.isElementOfType(teamSelector, TeamSelector)).toBe(true)
      expect(TestUtils.isElementOfType(teamSelector.props.awayElement, JamsList)).toBe(true)
      expect(TestUtils.isElementOfType(teamSelector.props.homeElement, JamsList)).toBe(true)
      expect(teamSelector.props.awayElement.props.team).toBe(gameState.away)
      expect(teamSelector.props.homeElement.props.team).toBe(gameState.home)
