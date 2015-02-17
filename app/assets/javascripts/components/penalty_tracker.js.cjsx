cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'
  
  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()
    gameState: exports.wftda.functions.camelize(this.props)

  render: () ->
    awayElement = <TeamPenalties teamState=this.state.gameState.awayAttributes />
    homeElement = <TeamPenalties teamState=this.state.gameState.homeAttributes />
    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
