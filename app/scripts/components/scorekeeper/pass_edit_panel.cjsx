React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'PassEditPanel'
  setPoints: (points) ->
    @props.actions.setPoints(points)
    $("##{@props.editPassId}").collapse('hide')
  render: () ->
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
    if @props.pass.passNumber == 1
      <div className="panel">
        <div className="edit-pass first-pass collapse" id={@props.editPassId}>
          <div className="row gutters-xs">
            <div className="col-sm-4 col-xs-4">
              <button className={injuryClass} onClick={@props.actions.toggleInjury}>
                <strong>Injury</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={leadClass} onClick={@props.actions.toggleLead}>
                <strong>Lead</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={callClass} onClick={@props.actions.toggleCalloff}>
                <strong>Call</strong>
              </button>
            </div>
          </div>
          <div className="row gutters-xs">
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
              <button className={nopassClass} onClick={@props.actions.toggleNopass}>
                <strong>No P.</strong>
              </button>
            </div>
          </div>
        </div>
      </div>
    else
      <div className="panel">
        <div className="edit-pass second-pass collapse" id={@props.editPassId}>
          <div className="row gutters-xs">
            <div className="col-sm-4 col-xs-4">
              <button className={injuryClass} onClick={@props.actions.toggleInjury}>
                <strong>Injury</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={lostClass} onClick={@props.actions.toggleLostLead}>
                <strong>Lost</strong>
              </button>
            </div>
            <div className="col-sm-4 col-xs-4">
              <button className={callClass} onClick={@props.actions.toggleCalloff}>
                <strong>Call</strong>
              </button>
            </div>
          </div>
          <div className="row gutters-xs">
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
