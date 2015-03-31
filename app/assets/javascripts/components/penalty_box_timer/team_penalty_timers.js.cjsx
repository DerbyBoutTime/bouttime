cx = React.addons.classSet
exports = exports ? this
exports.TeamPenaltyTimers = React.createClass
  displayName: 'TeamPenaltyTimers'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    jamNumber: React.PropTypes.number.isRequired
    actions: React.PropTypes.object.isRequired
  bindActions: (jamIndex, position) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, jamIndex, position)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  render: () ->
    jamIndex = Math.max(@props.jamNumber - 1, 0)
    jam = @props.teamState.jamStates[jamIndex]
    <div className="team-penalty-timers">
      <div className="row gutters-xs">
        <div className="col-xs-6">
          <button className="bt-btn undo-btn">UNDO</button>
        </div>
        <div className="col-xs-6">
          <button className="bt-btn edit-btn">
            <span>EDIT</span>
            <i className="glyphicon glyphicon-pencil"></i>
          </button>
        </div>
      </div>
      <section className="penalty-clocks">
        <PenaltyClock position='jammer' teamStyle={@props.teamState.colorBarStyle} boxState={jam.jammerBoxState} actions={@bindActions(jamIndex, 'jammer')} setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}/>
        <PenaltyClock position='blocker1' teamStyle={@props.teamState.colorBarStyle} boxState={jam.blocker1BoxState} actions={@bindActions(jamIndex, 'blocker1')} setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}/>
        <PenaltyClock position='blocker2' teamStyle={@props.teamState.colorBarStyle} boxState={jam.blocker2BoxState} actions={@bindActions(jamIndex, 'blocker2')} setSelectorContext={@props.actions.setSelectorContext.bind(null, jamIndex)}/>
      </section>
    </div>