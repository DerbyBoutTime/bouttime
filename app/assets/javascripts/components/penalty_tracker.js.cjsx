cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'

  mixins: [GameStateMixin]
  
  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()

  render: () ->
    awayElement = <TeamPenalties teamState={this.state.gameState.awayAttributes} penalties={this.state.gameState.penalties}/>
    homeElement = <TeamPenalties teamState={this.state.gameState.homeAttributes} penalties={this.state.gameState.penalties}/>
    
    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
