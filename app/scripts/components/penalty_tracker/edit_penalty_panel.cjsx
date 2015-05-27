React = require 'react/addons'
$ = require 'jquery'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'EditPenaltyPanel'
  propTypes:
    penaltyNumber: React.PropTypes.number
    skaterPenalty: React.PropTypes.object.isRequired
    incrementJamNumber: React.PropTypes.func.isRequired
    decrementJamNumber: React.PropTypes.func.isRequired
    clearPenalty: React.PropTypes.func.isRequired
    onOpen: React.PropTypes.func.isRequired
    onClose: React.PropTypes.func.isRequired
  clearPenalty: () ->
    @closePanel()
    @props.clearPenalty()
  closePanel: () ->
    $(@getDOMNode()).collapse('hide')
  componentDidMount: () ->
    $dom = $(@getDOMNode())
    $dom.on 'show.bs.collapse', (evt) =>
      $('.edit-penalty.collapse.in').collapse('hide')
    $dom.on 'shown.bs.collapse', (evt) =>
      @props.onOpen()
    $dom.on 'hide.bs.collapse', (evt) =>
      @props.onClose()
  render: () ->
    classArgs =
      'edit-penalty collapse': true
    classArgs["penalty-#{@props.penaltyNumber}"] = true
    containerClass = cx classArgs
    <div className={containerClass} id={@props.id}>
      <div className='row gutters-xs'>
        <div className='col-xs-1'>
          <button className='bt-btn btn-boxed action' onClick={@clearPenalty}>
            <span className='glyphicon glyphicon-trash'></span>
          </button>
        </div>
        <div className='col-xs-10'>
          <div className='jam-number-control boxed-good'>
            <button className='btn btn-boxed minus' onClick={@props.decrementJamNumber}>
              <span className='glyphicon glyphicon-minus'></span>
            </button>
            <strong>Jam {@props.skaterPenalty.jamNumber}</strong>
            <button className='btn btn-boxed plus' onClick={@props.incrementJamNumber}>
              <span className='glyphicon glyphicon-plus'></span>
            </button>
          </div>
        </div>
        <div className='col-xs-1'>
          <button className='bt-btn btn-boxed action' onClick={@closePanel}>
            <span className='glyphicon glyphicon-remove'></span>
          </button>
        </div>
      </div>
    </div>
