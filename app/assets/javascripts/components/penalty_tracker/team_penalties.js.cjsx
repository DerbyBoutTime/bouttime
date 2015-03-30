cx = React.addons.classSet
exports = exports ? this
exports.TeamPenalties = React.createClass
  displayName: 'TeamPenalties'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    penalties: React.PropTypes.array.isRequired
    currentJamNumber: React.PropTypes.number.isRequired
    applyHandler: React.PropTypes.func.isRequired
  getInitialState: () ->
    selectedSkaterIndex : null
  selectSkater: (skaterIndex) ->
    @refs.skaterPenalties.resetState()
    @setState(selectedSkaterIndex: skaterIndex)
  applySkaterPenalties:(workingSkaterState) ->
    @props.applyHandler(@state.selectedSkaterIndex, workingSkaterState.penaltyStates)
    @setState(selectedSkaterIndex: null)
  cancelSkaterPenalties: () ->
    @setState(selectedSkaterIndex: null)
  selectedSkater: () ->
    @props.teamState.skaterStates[@state.selectedSkaterIndex]
  render: () ->
    <div className="team-penalties">
      <PenaltiesSummary
        {...@props}
        teamStyle={@props.teamState.colorBarStyle}
        selectionHandler={@selectSkater}
        hidden={@state.selectedSkaterIndex?}/>
      <SkaterPenalties
        ref='skaterPenalties'
        skaterState={@selectedSkater()}
        penalties={@props.penalties}
        currentJamNumber={@props.currentJamNumber}
        applyHandler={@applySkaterPenalties}
        cancelHandler={@cancelSkaterPenalties}
        teamStyle={@props.teamState.colorBarStyle}
        hidden={!@state.selectedSkaterIndex?}/>
    </div>