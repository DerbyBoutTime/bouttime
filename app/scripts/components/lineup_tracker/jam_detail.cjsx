React = require 'react/addons'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
SkaterSelector = require '../shared/skater_selector.cjsx'
LineupBoxRow = require './lineup_box_row.cjsx'
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
  isInjured: (position) ->
    @props.jam.lineupStatuses.some (status) ->
      status[position] is 'injured'
  render: () ->
    noPivotButtonClass = cx
      'bt-btn': true
      'btn-selected': @props.jam.noPivot
    starPassButtonClass = cx
      'bt-btn': true
      'btn-selected': @props.jam.starPass
    actionsClass = cx
      'row': true
      'gutters-xs': true
      'actions': true
    pivotHeaderClass = cx
      'col-xs-5-cols text-center': true
      'hidden': @props.jam.noPivot
    blocker4HeaderClass = cx
      'col-xs-5-cols text-center': true
      'hidden': not @props.jam.noPivot
    pivotColumnClass = cx
      'col-xs-5-cols': true
      'hidden': @props.jam.noPivot
    blocker4ColumnClass = cx
      'col-xs-5-cols': true
      'hidden': not @props.jam.noPivot
    <div className="jam-detail">
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-6">
          <div className="jam-detail-number bt-box box-primary">
            <div className="row gutters-xs">
              <div className="col-xs-11">
                Jam {@props.jam.jamNumber}
              </div>
            </div>
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
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-5-cols text-center">
          <strong>J</strong>
        </div>
        <div className={pivotHeaderClass}>
          <strong>Pivot</strong>
        </div>
        <div className="col-xs-5-cols text-center">
          <strong>B1</strong>
        </div>
        <div className="col-xs-5-cols text-center">
          <strong>B2</strong>
        </div>
        <div className="col-xs-5-cols text-center">
          <strong>B3</strong>
        </div>
        <div className={blocker4HeaderClass}>
          <strong>B4</strong>
        </div>
      </div>
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jam.jammer}
            injured={@isInjured('jammer')}
            style={@props.team.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@setSkaterPosition}
            target="#lineup-selector-modal" />
        </div>
        <div className={pivotColumnClass}>
          <SkaterSelector
            skater={@props.jam.pivot}
            injured={@isInjured('pivot')}
            style={@props.team.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@setSkaterPosition}
            target="#lineup-selector-modal" />
        </div>
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jam.blocker1}
            injured={@isInjured('blocker1')}
            style={@props.team.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@setSkaterPosition}
            target="#lineup-selector-modal" />
        </div>
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jam.blocker2}
            injured={@isInjured('blocker2')}
            style={@props.team.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@setSkaterPosition}
            target="#lineup-selector-modal" />
        </div>
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jam.blocker3}
            injured={@isInjured('blocker3')}
            style={@props.team.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@setSkaterPosition}
            target="#lineup-selector-modal" />
        </div>
        <div className={blocker4ColumnClass}>
          <SkaterSelector
            skater={@props.jam.pivot}
            injured={@isInjured('pivot')}
            style={@props.team.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@setSkaterPosition}
            target="#lineup-selector-modal" />
        </div>
      </div>
      {@props.jam.lineupStatuses.map (lineupStatus, statusIndex) ->
        <LineupBoxRow key={statusIndex} lineupStatus={lineupStatus} cycleLineupStatus={@cycleLineupStatus.bind(this, statusIndex)} />
      , this }
      <LineupBoxRow key={@props.jam.lineupStatuses.length} cycleLineupStatus={@cycleLineupStatus.bind(this, @props.jam.lineupStatuses.length)} />
    </div>
