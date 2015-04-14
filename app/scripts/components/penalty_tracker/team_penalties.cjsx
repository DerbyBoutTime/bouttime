React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
PenaltiesSummary = require './penalties_summary.cjsx'
SkaterPenalties = require './skater_penalties.cjsx'
PenaltiesList = require './penalties_list.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    gameState: React.PropTypes.object.isRequired
    team: React.PropTypes.object.isRequired
  getInitialState: () ->
    selectedSkaterId: null
    editingPenaltyIndex: null
  selectSkater: (skaterId) ->
    @setState(selectedSkaterId: skaterId)
  editPenalty: (penaltyIndex) ->
    @setState(editingPenaltyIndex: penaltyIndex)
  backHandler: () ->
    $('.edit-penalty.collapse.in').collapse('hide')
    @selectSkater(null)
  setPenalty:(skaterId, penalty) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PENALTY
      skaterId: skaterId
      jamNumber: @props.gameState.jamNumber
      penalty: penalty
  changePenalty: (skaterId, skaterPenaltyIndex, penalty) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.UPDATE_PENALTY
      skaterId: skaterId
      skaterPenaltyIndex: skaterPenaltyIndex
      opts:
        penalty: penalty
  setOrUpdatePenalty: (skaterId, penaltyIndex) ->
    penalty = @props.gameState.penalties[penaltyIndex]
    if @state.editingPenaltyIndex?
      @changePenalty(skaterId, @state.editingPenaltyIndex, penalty)
    else
      @setPenalty(skaterId, penalty)
  render: () ->
    <div className="team-penalties">
      <PenaltiesSummary
        {...@props}
        selectionHandler={@selectSkater}
        hidden={@state.selectedSkaterId?}/>
      {@props.team.getSkaters().map (skater, skaterIndex) ->
        <SkaterPenalties
          key={skaterIndex}
          skater={skater}
          hidden={@state.selectedSkaterId isnt skater.id}
          backHandler={@backHandler}
          editHandler={@editPenalty}/>
      , this}
      <PenaltiesList
        penalties={@props.gameState.penalties}
        hidden={!@state.selectedSkaterId?}
        buttonHandler={@setOrUpdatePenalty.bind(this, @state.selectedSkaterId)} />
    </div>