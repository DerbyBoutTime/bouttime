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
    if !@props.jam.starPass
      @props.setSelectorContext(@setJammer)
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
  setJammer: (skaterId) ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.SET_PASS_JAMMER
      passId: @props.pass.id
      skaterId: skaterId
  isFirstPass: () ->
    @props.pass.passNumber == 1
  render: () ->
    leadColumnClass = cx
      'col-xs-3': true
      'hidden': not @isFirstPass()
    lostLeadColumnClass = cx
      'col-xs-3': true
      'hidden': @isFirstPass()
    firstPassScoreRowClass = cx
      'row gutters-xs top-buffer': true
      'hidden': not @isFirstPass()
    scoreRowClass = cx
      'row gutters-xs top-buffer': true
      'hidden': @isFirstPass()
    injuryClass = cx
      'bt-btn': true
      'btn-primary': @props.pass.injury
    nopassClass = cx
      'bt-btn': true
      'btn-primary': @props.pass.nopass
    callClass = cx
      'bt-btn': true
      'btn-primary': @props.pass.calloff
    lostClass = cx
      'bt-btn': true
      'btn-primary': @props.pass.lostLead
    leadClass = cx
      'bt-btn': true
      'btn-primary': @props.pass.lead
    starPassClass = cx
      'bt-btn': true
      'btn-primary': @props.jam.starPass and @props.jam.starPassNumber is @props.pass.passNumber
    scoreClass = (score) =>
      cx
        'bt-btn': true
        'btn-score': @props.pass.points isnt score
        'btn-primary': @props.pass.points is score
    <div className="panel">
      <div className="edit-pass collapse" id={@props.panelId}>
        <div className="row gutters-xs">
          <div className="col-xs-3">
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
          <div className="col-xs-3">
            <button className={callClass} onClick={@toggleCalloff}>
              <strong>Call</strong>
            </button>
          </div>
          <div className="col-xs-3">
            <button className={starPassClass} onClick={@setStarPass}>
              <strong><span className="glyphicon glyphicon-star" aria-hidden="true"></span> Pass</strong>
            </button>
          </div>
        </div>
        <div className={firstPassScoreRowClass}>
          <div className="col-xs-4">
            <button className={scoreClass(0)} onClick={@setPoints.bind(this, 0)}>
              <strong>0</strong>
            </button>
          </div>
          <div className="col-xs-4">
            <button className={scoreClass(1)} onClick={@setPoints.bind(this, 1)}>
              <strong>1</strong>
            </button>
          </div>
          <div className="col-xs-4">
            <button className={nopassClass} onClick={@toggleNopass}>
              <strong>No P.</strong>
            </button>
          </div>
        </div>
        <div className={scoreRowClass}>
          <div className="col-xs-11">
            <div className="row gutters-xs">
              <div className="col-xs-2">
                <button className={scoreClass(0)} onClick={@setPoints.bind(this, 0)}>
                  <strong>0</strong>
                </button>
              </div>
              <div className="col-xs-2">
                <button className={scoreClass(1)} onClick={@setPoints.bind(this, 1)}>
                  <strong>1</strong>
                </button>
              </div>
              <div className="col-xs-2">
                <button className={scoreClass(2)} onClick={@setPoints.bind(this, 2)}>
                  <strong>2</strong>
                </button>
              </div>
              <div className="col-xs-2">
                <button className={scoreClass(3)} onClick={@setPoints.bind(this, 3)}>
                  <strong>3</strong>
                </button>
              </div>
              <div className="col-xs-2">
                <button className={scoreClass(4)} onClick={@setPoints.bind(this, 4)}>
                  <strong>4</strong>
                </button>
              </div>
              <div className="col-xs-2">
                <button className={scoreClass(5)} onClick={@setPoints.bind(this, 5)}>
                  <strong>5</strong>
                </button>
              </div>
            </div>
          </div>
          <div className="col-xs-1">
            <button className={scoreClass(6)} onClick={@setPoints.bind(this, 6)}>
              <strong>6</strong>
            </button>
          </div>
        </div>
      </div>
    </div>