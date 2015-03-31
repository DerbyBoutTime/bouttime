cx = React.addons.classSet
exports = exports ? this
exports.JamDetail = React.createClass
  displayName: 'JamDetail'
  propTypes:
    teamAttributes: React.PropTypes.object.isRequired
    jamState: React.PropTypes.object.isRequired
    noPivotHandler: React.PropTypes.func.isRequired
    starPassHandler: React.PropTypes.func.isRequired
    lineupStatusHandler: React.PropTypes.func.isRequired
    setSelectorContextHandler: React.PropTypes.func.isRequired
    selectSkaterHandler: React.PropTypes.func.isRequired
  isInjured: (position) ->
    @props.jamState.lineupStatuses.some (status) ->
      status[position] is 'injured'
  render: () ->
    noPivotButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-no-pivot': true
      'toggle-pivot-btn': true
      'selected': @props.jamState.noPivot
    starPassButtonClass = cx
      'btn': true
      'btn-block': true
      'jam-detail-star-pass': true
      'toggle-star-pass-btn': true
      'selected': @props.jamState.starPass
    actionsClass = cx
      'row': true
      'gutters-xs': true
      'actions': true
    pivotHeaderClass = cx
      'col-xs-5-cols text-center': true
      'hidden': @props.jamState.noPivot
    blocker4HeaderClass = cx
      'col-xs-5-cols text-center': true
      'hidden': not @props.jamState.noPivot
    pivotColumnClass = cx
      'col-xs-5-cols': true
      'hidden': @props.jamState.noPivot
    blocker4ColumnClass = cx
      'col-xs-5-cols': true
      'hidden': not @props.jamState.noPivot

    <div className="jam-detail">
      <div className="row gutters-xs">
        <div className="col-xs-6">
          <div className="jam-detail-number boxed-good">
            <div className="row gutters-xs">
              <div className="col-sm-11 col-xs-11 col-xs-offset-1">
                Jam {@props.jamState.jamNumber}
              </div>
            </div>
          </div>
        </div>
        <div className="col-xs-3">
          <button className={noPivotButtonClass} onClick={@props.noPivotHandler}>
            <strong>No Pivot</strong>
          </button>
        </div>
        <div className="col-xs-3">
          <button className={starPassButtonClass} onClick={@props.starPassHandler}>
            <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
          </button>
        </div>
      </div>
      <div className="row gutters-xs positions">
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
      <div className="row gutters-xs skaters">
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jamState.jammer}
            injured={@isInjured('jammer')}
            style={@props.teamAttributes.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@props.selectSkaterHandler.bind(this, 'jammer')} />
        </div>
        <div className={pivotColumnClass}>
          <SkaterSelector
            skater={@props.jamState.pivot}
            injured={@isInjured('pivot')}
            style={@props.teamAttributes.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@props.selectSkaterHandler.bind(this, 'pivot')} />
        </div>
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jamState.blocker1}
            injured={@isInjured('blocker1')}
            style={@props.teamAttributes.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@props.selectSkaterHandler.bind(this, 'blocker1')} />
        </div>
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jamState.blocker2}
            injured={@isInjured('blocker2')}
            style={@props.teamAttributes.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@props.selectSkaterHandler.bind(this, 'blocker2')} />
        </div>
        <div className="col-xs-5-cols">
          <SkaterSelector
            skater={@props.jamState.blocker3}
            injured={@isInjured('blocker3')}
            style={@props.teamAttributes.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@props.selectSkaterHandler.bind(this, 'blocker3')} />
        </div>
        <div className={blocker4ColumnClass}>
          <SkaterSelector
            skater={@props.jamState.pivot}
            injured={@isInjured('pivot')}
            style={@props.teamAttributes.colorBarStyle}
            setSelectorContext={@props.setSelectorContextHandler}
            selectHandler={@props.selectSkaterHandler.bind(this, 'pivot')} />
        </div>
      </div>
      {@props.jamState.lineupStatuses.map (lineupStatus, statusIndex) ->
        <LineupBoxRow key={statusIndex} lineupStatus=lineupStatus lineupStatusHandler={@props.lineupStatusHandler.bind(this, statusIndex)} />
      , this }
      <LineupBoxRow key={@props.jamState.lineupStatuses.length} lineupStatusHandler={@props.lineupStatusHandler.bind(this, @props.jamState.lineupStatuses.length)} />
    </div>
