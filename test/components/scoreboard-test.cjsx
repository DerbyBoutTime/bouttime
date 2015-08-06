jest.dontMock('../../app/scripts/components/scoreboard')
React = require 'react/addons'
Scoreboard = require '../../app/scripts/components/scoreboard'
TestUtils = React.addons.TestUtils
DemoData = require '../../app/scripts/demo_data'
Promise = require 'bluebird'
describe 'Scoreboard', () ->
  process.setMaxListeners(0)
  gameState = null
  scoreboard = null
  container = document.createElement('div')
  beforeEach () ->
    gameState = DemoData.init()
    scoreboard = gameState.then (gameState) ->
      React.render <Scoreboard gameState={gameState} /> , container
  afterEach () ->
    React.unmountComponentAtNode(container)
  pit 'renders a component', () ->
    scoreboard.then (scoreboard) ->
      expect(TestUtils.isDOMComponent(scoreboard.getDOMNode()))
  pit "displays the current period", () ->
    scoreboard.then (scoreboard) ->
      periodContainer = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'period-number')
      expect(periodContainer.getDOMNode().textContent).toEqual('Pre')
  pit "displays the current jam number", () ->
    scoreboard.then (scoreboard) ->
      jamContainer = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'jam-number')
      expect(jamContainer.getDOMNode().textContent).toEqual('0')
  pit "display jam points", () ->
    scoreboard.then (scoreboard) ->
      TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'jam-points')
    .then (jamPoints) ->
      TestUtils.scryRenderedDOMComponentsWithClass(jamPoints, 'points')
    .spread (home, away) ->
      expect(home.getDOMNode().textContent).toEqual('0')
      expect(away.getDOMNode().textContent).toEqual('0')
  describe 'teams', () ->
    teams = null
    beforeEach () ->
      teams = scoreboard.then (scoreboard) -> TestUtils.scryRenderedDOMComponentsWithClass(scoreboard, 'team')
    pit "display names", () ->
      teams.spread (home, away) ->
        homeContainer = TestUtils.scryRenderedDOMComponentsWithClass(home, 'team-name')[0]
        awayContainer = TestUtils.scryRenderedDOMComponentsWithClass(away, 'team-name')[0]
        expect(homeContainer.getDOMNode().textContent).toEqual('Atlanta')
        expect(awayContainer.getDOMNode().textContent).toEqual('Gotham')
    pit "display logos", () ->
      teams.spread (home, away) ->
        homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'logo')
        awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'logo')
        expect(homeContainer.getDOMNode().firstChild.nodeName).toEqual('IMG')
        expect(awayContainer.getDOMNode().firstChild.nodeName).toEqual('IMG')
    pit "display game scores", () ->
      teams.spread (home, away) ->
        homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'score')
        awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'score')
        expect(homeContainer.getDOMNode().textContent).toEqual('0')
        expect(awayContainer.getDOMNode().textContent).toEqual('0')
    pit "display timeouts", () ->
      teams.spread (home, away) ->
        homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'timeouts')
        awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'timeouts')
        expect(homeContainer.getDOMNode().childNodes.length).toEqual(4)
        expect(awayContainer.getDOMNode().childNodes.length).toEqual(4)
    pit "display jammers with lead status", () ->
      teams.spread gameState, (home, away, gameState) ->
        gameState.home.jams[0].jammer = gameState.home.skaters[0]
        gameState.away.jams[0].jammer = gameState.away.skaters[0]
        gameState.home.jams[0].passes[0].lead = true
        gameState.jamNumber = 1
        scoreboard = TestUtils.renderIntoDocument <Scoreboard gameState={gameState} />    
        home = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'team home')
        away = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'team away')
        homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'jammer')
        homeName = TestUtils.findRenderedDOMComponentWithClass(homeContainer, 'name')
        homeLead = TestUtils.findRenderedDOMComponentWithClass(homeContainer, 'lead-status')
        awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'jammer')
        awayName = TestUtils.findRenderedDOMComponentWithClass(awayContainer, 'name')
        awayLead = TestUtils.findRenderedDOMComponentWithClass(awayContainer, 'lead-status')
        expect(homeName.getDOMNode().textContent).toEqual("6 Wild Cherri")
        expect(homeLead.getDOMNode().firstChild.className).not.toContain('hidden')
        expect(awayName.getDOMNode().textContent).toEqual("00 Ana Bollocks")
        expect(awayLead.getDOMNode().firstChild.className).toContain('hidden')
