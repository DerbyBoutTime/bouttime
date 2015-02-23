cx = React.addons.classSet
exports = exports ? this
exports.PenaltyTracker = React.createClass
  displayName: 'PenaltyTracker'

  mixins: [GameStateMixin]

  setPenaltyStates: (teamType, skaterIndex, penaltyStates) ->
    skater = this.getSkaterState(teamType, skaterIndex)
    skater.penaltyStates = penaltyStates.map (penaltyState) -> $.extend(true, {}, penaltyState)
    this.setState(this.state)
  
  getInitialState: () ->
    componentId: exports.wftda.functions.uniqueId()

  render: () ->
    awayElement = <TeamPenalties teamState={this.state.gameState.awayAttributes} penalties={this.state.gameState.penalties} currentJamNumber={this.props.jamNumber} applyHandler={this.setPenaltyStates.bind(this, 'away')}/>
    homeElement = <TeamPenalties teamState={this.state.gameState.homeAttributes} penalties={this.state.gameState.penalties} currentJamNumber={this.props.jamNumber} applyHandler={this.setPenaltyStates.bind(this, 'home')}/>
    
    <div className="penalty-tracker">
      <TeamSelector
        awayAttributes={this.state.gameState.awayAttributes}
        awayElement={awayElement}
        homeAttributes={this.state.gameState.homeAttributes}
        homeElement={homeElement} />
   	</div>
