cx = React.addons.classSet
exports = exports ? this
exports.SkaterPenalties = React.createClass
  displayName: 'SkaterPenalties'
  propTypes:
    skaterState: React.PropTypes.object.isRequired
    actions: React.PropTypes.object.isRequired
    teamStyle: React.PropTypes.object
    hidden: React.PropTypes.bool
    backHandler: React.PropTypes.func.isRequired
    editHandler: React.PropTypes.func.isRequired
  bindActions: (penaltyIndex) ->
    Object.keys(@props.actions).map((key) ->
      key: key
      value: @props.actions[key].bind(this, penaltyIndex)
    , this).reduce((actions, action) ->
      actions[action.key] = action.value
      actions
    , {})
  getPenaltyId: (penaltyIndex) ->
    "edit-penalty-#{@props.skaterState.id}-#{penaltyIndex}"
  render: () ->
    containerClass = cx
      'skater-penalties': true
      'hidden': @props.hidden
    <div className={containerClass}>
      <div className='row gutters-xs top-buffer actions' >
        <div className='col-xs-12'>
          <button className='bt-btn btn-boxed action' onClick={@props.backHandler} >
            <span className='icon glyphicon glyphicon-chevron-left'></span><strong>Back</strong>
          </button>
        </div>
      </div>
      <div className='row gutters-xs top-buffer'>
        <div className='col-xs-2'>
          <div className='bt-btn btn-boxed' style={@props.teamStyle}>
            <strong>{@props.skaterState.skater.number}</strong>
          </div>
        </div>
        <div className='col-xs-offset-7 col-xs-3'>
          <PenaltyAlert skaterState={@props.skaterState} />
        </div>
      </div>
      <div className='row gutters-xs top-buffer penalty-controls'>
        {[0...7].map (i) ->
          <div key={i} className='col-xs-7-cols'>
            <PenaltyControl
              penaltyNumber={i+1}
              penaltyState={@props.skaterState.penaltyStates[i]}
              teamStyle={@props.teamStyle}
              target={@getPenaltyId(i)} />
          </div>
        , this}
      </div>
      <div className='row gutters-xs'>
        <div className='col-xs-12'>
          {@props.skaterState.penaltyStates[...7].map (penaltyState, penaltyIndex) ->
            <EditPenaltyPanel
              key={penaltyIndex}
              id={@getPenaltyId(penaltyIndex)}
              penaltyState={penaltyState}
              penaltyNumber={penaltyIndex+1}
              actions={@bindActions(penaltyIndex)}
              onOpen={@props.editHandler.bind(null, penaltyIndex)}
              onClose={@props.editHandler.bind(null, null)}/>
          , this}
        </div>
      </div>
      <div className='row-gutters-xs penalty-controls'>
        <div className='col-xs-10'>
          <div className='row gutters-xs'>
            {@props.skaterState.penaltyStates[7..].map (penaltyState, penaltyIndex) ->
              <div key={penaltyIndex} className='col-xs-2'>
                <PenaltyControl
                  penaltyNumber={penaltyIndex + 1}
                  penaltyState={penaltyState}
                  teamStyle={@props.teamStyle}
                  target={@getPenaltyId(penaltyIndex + 7)} />
              </div>
            , this}
          </div>
        </div>
      </div>
      <div className='row gutters-xs'>
        <div className='col-xs-12'>
          {@props.skaterState.penaltyStates[7..].map (penaltyState, penaltyIndex) ->
            <EditPenaltyPanel
              key={penaltyIndex}
              id={@getPenaltyId(penaltyIndex + 7)}
              penaltyState={penaltyState}
              penaltyNumber={penaltyIndex+1}
              actions={@bindActions(penaltyIndex + 7)}
              onOpen={@props.editHandler.bind(null, penaltyIndex + 7)}
              onClose={@props.editHandler.bind(null, null)}/>
          , this}
        </div>
      </div>
    </div>