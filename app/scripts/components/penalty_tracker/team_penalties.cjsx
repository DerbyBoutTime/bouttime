React = require 'react/addons'
PenaltiesSummary = require './penalties_summary.cjsx'
SkaterPenalties = require './skater_penalties.cjsx'
PenaltiesList = require './penalties_list.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    team: React.PropTypes.object.isRequired
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
        teamStyle={@props.team.colorBarStyle}
        selectionHandler={@selectSkater}
        hidden={@state.selectedSkaterIndex?}/>
      {@props.team.skaters.map (skater, skaterIndex) ->
        <SkaterPenalties
          key={skaterIndex}
          skater={@props.team.skaters[skaterIndex]}
          actions={@bindActions(skaterIndex)}
          teamStyle={@props.team.colorBarStyle}
          hidden={@state.selectedSkaterIndex isnt skaterIndex}
          backHandler={@backHandler}
          editHandler={@editPenalty}/>
      , this}
      <PenaltiesList
        penalties={@props.penalties}
        hidden={!@state.selectedSkaterIndex?}
        buttonHandler={@setOrUpdatePenalty.bind(this, @state.selectedSkaterIndex)} />
    </div>