cx = React.addons.classSet
exports = exports ? this
exports.TeamPenaltyTimers = React.createClass
  displayName: 'TeamPenaltyTimers'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    jamNumber: React.PropTypes.number.isRequired
    actions: React.PropTypes.object.isRequired
  bindActions: (boxIndex) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, boxIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  render: () ->
    jamIndex = Math.max(@props.jamNumber - 1, 0)
    hideJammer = @props.teamState.penaltyBoxStates.some (boxState) ->
      boxState.position is 'jammer' and not boxState.served
    visibleBlockers = 4 - @props.teamState.penaltyBoxStates.filter((boxState) -> boxState.position is 'blocker' and not boxState.served).length
    <div className="team-penalty-timers">
      <div className="row gutters-xs">
        <div className="col-xs-12">
          <button className="bt-btn edit-btn">
            <span>EDIT</span>
            <i className="glyphicon glyphicon-pencil"></i>
          </button>
        </div>
      </div>
      <section className="penalty-clocks">
        {@props.teamState.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock key={boxIndex}
            teamStyle={@props.teamState.colorBarStyle}
            boxState={boxState} actions={@bindActions(boxIndex)}
            setSelectorContext={@props.actions.setSelectorContext.bind(this, jamIndex)}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'jammer'
        , this}
        <PenaltyClock
          teamStyle={@props.teamState.colorBarStyle}
          boxState={position: 'jammer'}
          actions={@bindActions('jammer')}
          setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}
          hidden={hideJammer}/>
        {@props.teamState.penaltyBoxStates.map((boxState, boxIndex) ->
          <PenaltyClock key={boxIndex}
            teamStyle={@props.teamState.colorBarStyle}
            boxState={boxState}
            actions={@bindActions(boxIndex)}
            setSelectorContext={@props.actions.setSelectorContext.bind(this, jamIndex)}
            hidden={boxState.served}/>
        , this).filter (component) ->
          component.props.boxState.position is 'blocker'
        , this}
        {[0...visibleBlockers].map (i) ->
          <PenaltyClock key={i}
            teamStyle={@props.teamState.colorBarStyle}
            boxState={position: 'blocker'}
            actions={@bindActions('blocker')}
            setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}/>
        , this}
      </section>
    </div>