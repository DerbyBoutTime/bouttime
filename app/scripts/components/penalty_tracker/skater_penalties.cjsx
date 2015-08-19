React = require 'react/addons'
_ = require 'underscore'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
PenaltyAlert = require './penalty_alert.cjsx'
PenaltyControl = require './penalty_control.cjsx'
EditPenaltyPanel = require './edit_penalty_panel.cjsx'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'SkaterPenalties'
  propTypes:
    skater: React.PropTypes.object.isRequired
    team: React.PropTypes.object.isRequired
    hidden: React.PropTypes.bool
    backHandler: React.PropTypes.func.isRequired
    editHandler: React.PropTypes.func.isRequired
  incrementJamNumber: (skaterPenaltyIndex) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.UPDATE_PENALTY
      skaterId: @props.skater.id
      skaterPenaltyIndex: skaterPenaltyIndex
      opts:
        jamNumber: @props.skater.penalties[skaterPenaltyIndex].jamNumber + 1
  decrementJamNumber: (skaterPenaltyIndex) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.UPDATE_PENALTY
      skaterId: @props.skater.id
      skaterPenaltyIndex: skaterPenaltyIndex
      opts:
        jamNumber: Math.max(@props.skater.penalties[skaterPenaltyIndex].jamNumber - 1, 1)
  clearPenalty: (skaterPenaltyIndex) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CLEAR_PENALTY
      skaterId: @props.skater.id
      skaterPenaltyIndex: skaterPenaltyIndex
  toggleSat: (skaterPenaltyIndex) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.UPDATE_PENALTY
      skaterId: @props.skater.id
      skaterPenaltyIndex: skaterPenaltyIndex
      opts:
        sat: not @props.skater.penalties[skaterPenaltyIndex].sat
  toggleSeverity: (skaterPenaltyIndex) ->
    penalty = @props.skater.penalties[skaterPenaltyIndex]?.penalty
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.UPDATE_PENALTY
      skaterId: @props.skater.id
      skaterPenaltyIndex: skaterPenaltyIndex
      opts:
        penalty: _.extend penalty, egregious: not penalty?.egregious
  getPenaltyId: (penaltyIndex) ->
    "edit-penalty-#{@props.skater.id}-#{penaltyIndex}"
  render: () ->
    containerClass = cx
      'skater-penalties': true
      'hidden': @props.hidden
    <div className={containerClass}>
      <div className='row gutters-xs top-buffer' >
        <div className='col-xs-12'>
          <button className='bt-btn btn-primary' onClick={@props.backHandler} >
            <span className='icon glyphicon glyphicon-chevron-left'></span><strong>Back</strong>
          </button>
        </div>
      </div>
      <div className='row gutters-xs top-buffer'>
        <div className='col-xs-2'>
          <div className='bt-btn' style={@props.teamStyle}>
            <strong>{@props.skater.number}</strong>
          </div>
        </div>
        <div className='col-xs-offset-7 col-xs-3'>
          <PenaltyAlert skater={@props.skater} />
        </div>
      </div>
      <div className='row gutters-xs top-buffer'>
        {[0...7].map (i) ->
          <div key={i} className='col-xs-7-cols'>
            <PenaltyControl
              penaltyNumber={i+1}
              skaterPenalty={@props.skater.penalties[i]}
              teamStyle={@props.team.colorBarStyle}
              target={@getPenaltyId(i)} />
          </div>
        , this}
      </div>
      <div className='row gutters-xs'>
        <div className='col-xs-12'>
          {@props.skater.penalties[...7].map (skaterPenalty, penaltyIndex) ->
            <EditPenaltyPanel
              key={penaltyIndex}
              id={@getPenaltyId(penaltyIndex)}
              skaterPenalty={skaterPenalty}
              penaltyNumber={penaltyIndex+1}
              incrementJamNumber={@incrementJamNumber.bind(this, penaltyIndex)}
              decrementJamNumber={@decrementJamNumber.bind(this, penaltyIndex)}
              clearPenalty={@clearPenalty.bind(this, penaltyIndex)}
              toggleSat={@toggleSat.bind(this, penaltyIndex)}
              toggleSeverity={@toggleSeverity.bind(this, penaltyIndex)}
              onOpen={@props.editHandler.bind(null, penaltyIndex)}
              onClose={@props.editHandler.bind(null, null)}/>
          , this}
        </div>
      </div>
      <div className='row gutters-xs'>
        <div className='row gutters-xs'>
          {@props.skater.penalties[7..].map (skaterPenalty, penaltyIndex) ->
            <div key={penaltyIndex} className='col-xs-7-cols'>
              <PenaltyControl
                penaltyNumber={penaltyIndex + 8}
                skaterPenalty={skaterPenalty}
                teamStyle={@props.teamStyle}
                target={@getPenaltyId(penaltyIndex + 7)} />
            </div>
          , this}
        </div>
      </div>
      <div className='row gutters-xs'>
        <div className='col-xs-12'>
          {@props.skater.penalties[7..].map (skaterPenalty, penaltyIndex) ->
            <EditPenaltyPanel
              key={penaltyIndex}
              id={@getPenaltyId(penaltyIndex + 7)}
              skaterPenalty={skaterPenalty}
              penaltyNumber={penaltyIndex+8}
              incrementJamNumber={@incrementJamNumber.bind(this, penaltyIndex + 7)}
              decrementJamNumber={@decrementJamNumber.bind(this, penaltyIndex + 7)}
              clearPenalty={@clearPenalty.bind(this, penaltyIndex + 7)}
              toggleSat={@toggleSat.bind(this, penaltyIndex + 7)}
              toggleSeverity={@toggleSeverity.bind(this, penaltyIndex + 7)}
              onOpen={@props.editHandler.bind(null, penaltyIndex + 7)}
              onClose={@props.editHandler.bind(null, null)}/>
          , this}
        </div>
      </div>
    </div>