cx = React.addons.classSet
exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    actions: React.PropTypes.object.isRequired
  getInitialState: () ->
    selectedSkaterIndex: null
    editingPenaltyIndex: null
  selectSkater: (skaterIndex) ->
    @setState(selectedSkaterIndex: skaterIndex)
  editPenalty: (penaltyIndex) ->
    @setState(editingPenaltyIndex: penaltyIndex)
  backHandler: () ->
    $('.edit-penalty.collapse.in').collapse('hide')
    @selectSkater(null)
  setOrUpdatePenalty: (skaterIndex, penaltyIndex) ->
    if @state.editingPenaltyIndex?
      penalty = @props.penalties[penaltyIndex]
      @props.actions.updatePenalty(skaterIndex, @state.editingPenaltyIndex, {penalty: penalty})
    else
      @props.actions.setPenalty(skaterIndex, penaltyIndex)
  bindActions: (skaterIndex) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, skaterIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  render: () ->
    <div className="team-penalties">
      <PenaltiesSummary
        {...@props}
        teamStyle={@props.teamState.colorBarStyle}
        selectionHandler={@selectSkater}
        hidden={@state.selectedSkaterIndex?}/>
      {@props.teamState.skaterStates.map (skaterState, skaterIndex) ->
        <SkaterPenalties
          key={skaterIndex}
          skaterState={@props.teamState.skaterStates[skaterIndex]}
          actions={@bindActions(skaterIndex)}
          teamStyle={@props.teamState.colorBarStyle}
          hidden={@state.selectedSkaterIndex isnt skaterIndex}
          backHandler={@backHandler}
          editHandler={@editPenalty}/>
      , this}
      <PenaltiesList
        penalties={@props.penalties}
        hidden={!@state.selectedSkaterIndex?}
        buttonHandler={@setOrUpdatePenalty.bind(this, @state.selectedSkaterIndex)} />
    </div>