cx = React.addons.classSet
exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    actions: React.PropTypes.object.isRequired
  getInitialState: () ->
    selectedSkaterIndex : null
  selectSkater: (skaterIndex) ->
    this.setState(selectedSkaterIndex: skaterIndex)
  bindActions: (skaterIndex) ->
    Object.keys(this.props.actions).map((key) ->
      key: key
      value: this.props.actions[key].bind(this, skaterIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  render: () ->
    <div className="team-penalties">
      <PenaltiesSummary
        {...this.props}
        teamStyle={this.props.teamState.colorBarStyle}
        selectionHandler={this.selectSkater}
        hidden={this.state.selectedSkaterIndex?}/>
      {this.props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <SkaterPenalties
          key={skaterIndex}
          skaterState={this.props.teamState.skaterStates[skaterIndex]}
          actions={this.bindActions(skaterIndex)}
          teamStyle={this.props.teamState.colorBarStyle}
          hidden={this.state.selectedSkaterIndex isnt skaterIndex}
          backHandler={this.selectSkater.bind(this, null)}/>
      , this}
      <PenaltiesList
        penalties={this.props.penalties}
        actions={this.bindActions(this.state.selectedSkaterIndex)}
        hidden={!this.state.selectedSkaterIndex?} />
    </div>