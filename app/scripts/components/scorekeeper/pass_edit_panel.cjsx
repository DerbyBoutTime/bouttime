React = require 'react/addons'
$ = require 'jquery'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PassEditPanel'
  toggleInjury: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_INJURY
      passId: @props.pass.id
  toggleNopass: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_NOPASS
      passId: @props.pass.id
  toggleCalloff: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_CALLOFF
      passId: @props.pass.id
  toggleLostLead: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_LOST_LEAD
      passId: @props.pass.id
  toggleLead: () ->
    $("##{@props.editPassId}").collapse('hide')
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.TOGGLE_LEAD
      passId: @props.pass.id
  setStarPass: () ->
    if !@props.jam.pivot?
      @props.selectPivot()
      $("#skater-selector-modal").modal('show')
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_STAR_PASS
      passId: @props.pass.id
    $("##{@props.editPassId}").collapse('hide')
  setPoints: (points) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_POINTS
      passId: @props.pass.id
      points: points
    $("##{@props.editPassId}").collapse('hide')
  isFirstPass: () ->
    @props.pass.passNumber == 1
  render: () ->
    leadColumnClass = cx
      'col-sm-3 col-xs-3': true
      'hidden': not @isFirstPass()
    lostLeadColumnClass = cx
      'col-sm-3 col-xs-3': true
      'hidden': @isFirstPass()
    firstPassScoreRowClass = cx
      'row gutters-xs': true
      'hidden': not @isFirstPass()
    scoreRowClass = cx
      'row gutters-xs': true
      'hidden': @isFirstPass()
    injuryClass = cx
      'bt-btn notes injury': true
      'selected': @props.pass.injury
    nopassClass = cx
      'bt-btn notes no-pass': true
      'selected': @props.pass.nopass
    callClass = cx
      'bt-btn notes call': true
      'selected': @props.pass.calloff
    lostClass = cx
      'bt-btn notes lost': true
      'selected': @props.pass.lostLead
    leadClass = cx
      'bt-btn notes note-lead': true
      'selected': @props.pass.lead
    starPassClass = cx
      'bt-btn notes star-pass': true
      'selected': @props.jam.starPass and @props.jam.starPassNumber is @props.pass.passNumber
    zeroClass = cx
      'bt-btn scores zero': true
      'selected': @props.pass.points == 0
    oneClass = cx
      'bt-btn scores one': true
      'selected': @props.pass.points == 1
    twoClass = cx
      'bt-btn scores two': true
      'selected': @props.pass.points == 2
    threeClass = cx
      'bt-btn scores three': true
      'selected': @props.pass.points == 3
    fourClass = cx
      'bt-btn scores four': true
      'selected': @props.pass.points == 4
    fiveClass = cx
      'bt-btn scores five': true
      'selected': @props.pass.points == 5
    sixClass = cx
      'bt-btn scores six': true
      'selected': @props.pass.points == 6
    <div className="panel">
      <div className="edit-pass collapse" id={@props.panelId}>
        <div className="row gutters-xs">
          <div className="col-sm-3 col-xs-3">
            <button className={injuryClass} onClick={@toggleInjury}>
              <strong>Injury</strong>
            </button>
          </div>
          <div className={leadColumnClass}>
            <button className={leadClass} onClick={@toggleLead}>
              <strong>Lead</strong>
            </button>
          </div>
          <div className={lostLeadColumnClass}>
            <button className={lostClass} onClick={@toggleLostLead}>
              <strong>Lost</strong>
            </button>
          </div>
          <div className="col-sm-3 col-xs-3">
            <button className={callClass} onClick={@toggleCalloff}>
              <strong>Call</strong>
            </button>
          </div>
          <div className="col-sm-3 col-xs-3">
            <button className={starPassClass} onClick={@setStarPass}>
              <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
            </button>
          </div>
        </div>
        <div className={firstPassScoreRowClass}>
          <div className="col-sm-4 col-xs-4">
            <button className={zeroClass} onClick={@setPoints.bind(this, 0)}>
              <strong>0</strong>
            </button>
          </div>
          <div className="col-sm-4 col-xs-4">
            <button className={oneClass} onClick={@setPoints.bind(this, 1)}>
              <strong>1</strong>
            </button>
          </div>
          <div className="col-sm-4 col-xs-4">
            <button className={nopassClass} onClick={@toggleNopass}>
              <strong>No P.</strong>
            </button>
          </div>
        </div>
        <div className={scoreRowClass}>
          <div className="col-sm-11 col-xs-11">
            <div className="row gutters-xs">
              <div className="col-sm-2 col-xs-2">
                <button className={zeroClass} onClick={@setPoints.bind(this, 0)}>
                  <strong>0</strong>
                </button>
              </div>
              <div className="col-sm-2 col-xs-2">
                <button className={oneClass} onClick={@setPoints.bind(this, 1)}>
                  <strong>1</strong>
                </button>
              </div>
              <div className="col-sm-2 col-xs-2">
                <button className={twoClass} onClick={@setPoints.bind(this, 2)}>
                  <strong>2</strong>
                </button>
              </div>
              <div className="col-sm-2 col-xs-2">
                <button className={threeClass} onClick={@setPoints.bind(this, 3)}>
                  <strong>3</strong>
                </button>
              </div>
              <div className="col-sm-2 col-xs-2">
                <button className={fourClass} onClick={@setPoints.bind(this, 4)}>
                  <strong>4</strong>
                </button>
              </div>
              <div className="col-sm-2 col-xs-2">
                <button className={fiveClass} onClick={@setPoints.bind(this, 5)}>
                  <strong>5</strong>
                </button>
              </div>
            </div>
          </div>
          <div className="col-sm-1 col-xs-1">
            <button className={sixClass} onClick={@setPoints.bind(this, 6)}>
              <strong>6</strong>
            </button>
          </div>
        </div>
      </div>
    </div>