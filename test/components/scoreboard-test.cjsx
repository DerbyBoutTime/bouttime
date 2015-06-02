jest.dontMock('../../app/scripts/components/scoreboard')
React = require 'react/addons'
Scoreboard = require '../../app/scripts/components/scoreboard'
TestUtils = React.addons.TestUtils
DemoData = require '../../app/scripts/demo_data'

describe 'Scoreboard', () ->
  gameState = null
  scoreboard = null
  container = document.createElement('div')
  beforeEach () ->
    gameState = DemoData.init()
    scoreboard = React.render <Scoreboard gameState={gameState} /> , container
  afterEach () ->
    React.unmountComponentAtNode(container)
  it 'renders a component', () ->
    expect(TestUtils.isDOMComponent(scoreboard.getDOMNode()))
  it "displays the current period", () ->
    periodContainer = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'period-number')
    expect(periodContainer.getDOMNode().textContent).toEqual('Pregame')
  it "displays the current jam number", () ->
    jamContainer = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'jam-number')
    expect(jamContainer.getDOMNode().textContent).toEqual('0')
  it "indicate the lead jammer", () ->
  describe 'teams', () ->
    home = null
    away = null
    beforeEach () ->
      home = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'team home')
      away = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'team away')
    it "display names", () ->
      homeContainer = TestUtils.scryRenderedDOMComponentsWithClass(home, 'name')[0]
      awayContainer = TestUtils.scryRenderedDOMComponentsWithClass(away, 'name')[0]
      expect(homeContainer.getDOMNode().textContent).toEqual('Atlanta Rollergirls')
      expect(awayContainer.getDOMNode().textContent).toEqual('Gotham')
    it "display logos", () ->
      homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'logo')
      awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'logo')
      expect(homeContainer.getDOMNode().firstChild.nodeName).toEqual('IMG')
      expect(awayContainer.getDOMNode().firstChild.nodeName).toEqual('IMG')
    it "display game scores", () ->
      homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'score')
      awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'score')
      expect(homeContainer.getDOMNode().textContent).toEqual('0')
      expect(awayContainer.getDOMNode().textContent).toEqual('0')
    it "display jam points", () ->
      homeContainer = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'home-team-jam-points')
      awayContainer = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'away-team-jam-points')
      expect(homeContainer.getDOMNode().textContent).toEqual('0')
      expect(awayContainer.getDOMNode().textContent).toEqual('0')
    it "display timeouts", () ->
      homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'timeouts')
      awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'timeouts')
      expect(homeContainer.getDOMNode().childNodes.length).toEqual(4)
      expect(awayContainer.getDOMNode().childNodes.length).toEqual(4)
    it "display jammers", () ->
      gameState.home.jams[0].jammer = gameState.home.skaters[0]
      gameState.away.jams[0].jammer = gameState.away.skaters[0]
      gameState.jamNumber = 1
      scoreboard = TestUtils.renderIntoDocument <Scoreboard gameState={gameState} />    
      home = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'team home')
      away = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'team away')
      homeContainer = TestUtils.findRenderedDOMComponentWithClass(home, 'jammer')
      homeName = TestUtils.findRenderedDOMComponentWithClass(homeContainer, 'name')
      awayContainer = TestUtils.findRenderedDOMComponentWithClass(away, 'jammer')
      awayName = TestUtils.findRenderedDOMComponentWithClass(awayContainer, 'name')
      expect(homeName.getDOMNode().textContent).toEqual("6 Wild Cherri")
      expect(awayName.getDOMNode().textContent).toEqual("00 Ana Bollocks")
  describe 'alerts', () ->
    alerts = null
    beforeEach () ->
      alerts = TestUtils.findRenderedDOMComponentWithClass(scoreboard, 'alerts')
    it "display home alerts", () ->
      alertContainer = TestUtils.findRenderedDOMComponentWithClass(alerts, 'alert-home')
      expect(alertContainer.getDOMNode().childNodes.length).toEqual(4)
    it "display away alerts", () ->
      alertContainer = TestUtils.findRenderedDOMComponentWithClass(alerts, 'alert-away')
      expect(alertContainer.getDOMNode().childNodes.length).toEqual(4)
    it "display neutral alerts", () ->
      alertContainer = TestUtils.findRenderedDOMComponentWithClass(alerts, 'alert-neutral')
      expect(alertContainer.getDOMNode().childNodes.length).toEqual(4)
