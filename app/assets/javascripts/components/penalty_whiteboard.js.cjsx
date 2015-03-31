cx = React.addons.classSet
exports = exports ? this
exports.PenaltyWhiteboard = React.createClass
  displayName: 'PenaltyWhiteBoard'
  render: () ->
    awayElement = <PenaltiesSummary teamState={@props.gameState.awayAttributes}/>
    homeElement = <PenaltiesSummary teamState={@props.gameState.homeAttributes}/>
    <div className="penalty-whiteboard">
      <TeamSelector
        awayAttributes={@props.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={@props.gameState.homeAttributes}
        homeElement={homeElement} />
    </div>
