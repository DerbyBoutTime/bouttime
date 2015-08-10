React = require 'react/addons'
cx = React.addons.classSet
ReactCSSTransitionGroup = React.addons.CSSTransitionGroup
constants = require '../../constants'
module.exports = React.createClass
  displayName: 'ScoreboardAds'
  propTypes:
    gameState: React.PropTypes.object.isRequired
  componentDidMount: () ->
    @interval = setInterval(@cycleAd, constants.AD_DISPLAY_TIME_IN_MS)
  componentWillUnmount: () ->
    clearInterval(@interval)
  getInitialState: () ->
    adIndex: 0
  cycleAd: () ->
    @setState adIndex: (@state.adIndex + 1) % @props.gameState.ads.length
  render: () ->
    containerClass = cx
      'ads': true
    <div className={containerClass}>
      <ReactCSSTransitionGroup transitionName="carousel">
        <div className="scoreboard-ad" key={@state.adIndex}>
          <img src={@props.gameState.ads[@state.adIndex]}/>
        </div>
      </ReactCSSTransitionGroup>
    </div>

