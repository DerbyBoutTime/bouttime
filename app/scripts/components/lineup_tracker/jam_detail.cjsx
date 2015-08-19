React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
SkaterSelector = require '../shared/skater_selector'
ItemRow = require '../shared/item_row'
LineupBoxRow = require './lineup_box_row'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'JamDetail'
  propTypes:
    team: React.PropTypes.object.isRequired
    jam: React.PropTypes.object.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
  toggleNoPivot: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_NO_PIVOT
      jamId: @props.jam.id
  toggleStarPass: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_STAR_PASS
      jamId: @props.jam.id
  setSkaterPosition: (position, skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_SKATER_POSITION
      jamId: @props.jam.id
      position: position
      skaterId: skaterId
  cycleLineupStatus: (statusIndex, position) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CYCLE_LINEUP_STATUS
      jamId: @props.jam.id
      statusIndex: statusIndex
      position: position
  removeJam: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REMOVE_JAM
      jamId: @props.jam.id
  renderItem: () ->
    noPivotButtonClass = cx
      'bt-btn': true
      'btn-selected': @props.jam.noPivot
    starPassButtonClass = cx
      'bt-btn': true
      'btn-selected': @props.jam.starPass
    <div>
      <div className="col-xs-5">
        <div className="bt-box box-primary">
          <strong>Jam {@props.jam.jamNumber}</strong>
        </div>
      </div>
      <div className="col-xs-3">
        <button className={noPivotButtonClass} onClick={@toggleNoPivot}>
          <strong>No Pivot</strong>
        </button>
      </div>
      <div className="col-xs-3">
        <button className={starPassButtonClass} onClick={@toggleStarPass}>
          <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
        </button>
      </div>
    </div>
  renderPanel: () ->
    actionsClass = cx
      'row': true
      'gutters-xs': true
      'actions': true
    <div>
      <div className="row gutters-xs top-buffer">
        {@props.jam.listPositionLabels().map (pos) ->
          <div key={pos} className="col-xs-5-cols text-center">
            <strong>{pos}</strong>
          </div>
        , this}
      </div>
      <div className="row gutters-xs top-buffer">
        {@props.jam.listPositions().map (pos) ->
          <div key={pos} className='col-xs-5-cols'>
            <SkaterSelector
              skater={@props.jam[pos]}
              injured={@props.jam.isInjured(pos)}
              style={@props.team.colorBarStyle}
              setSelectorContext={@props.setSelectorContextHandler}
              selectHandler={@setSkaterPosition}
              target="#lineup-selector-modal" /> 
          </div>         
        , this}
      </div>
      {@props.jam.lineupStatuses.map (lineupStatus, statusIndex) ->
        <LineupBoxRow
          key={statusIndex}
          lineupStatus={lineupStatus}
          cycleLineupStatus={@cycleLineupStatus.bind(this, statusIndex)}
          positions={@props.jam.listPositions()} />
      , this }
      <LineupBoxRow
        key={@props.jam.lineupStatuses.length}
        cycleLineupStatus={@cycleLineupStatus.bind(this, @props.jam.lineupStatuses.length)}
        positions={@props.jam.listPositions()} />
    </div>
  render: () ->
    <div className='jam-detail'>
      <ItemRow
        item={@renderItem()}
        removeHandler={@removeJam}
        panel={@renderPanel()} />
    </div>
