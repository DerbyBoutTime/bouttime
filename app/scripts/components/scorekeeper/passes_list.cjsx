React = require 'react/addons'
$ = require 'jquery'
functions = require '../../functions'
AppDispatcher = require '../../dispatcher/app_dispatcher.coffee'
{ActionTypes} = require '../../constants.coffee'
PassItem = require './pass_item.cjsx'
module.exports = React.createClass
  displayName: 'PassesList'
  propTypes:
    jam: React.PropTypes.object.isRequired
    setSelectorContext: React.PropTypes.func.isRequired
  mouseDownHandler: (evt) ->
    @target = evt.target
  dragHandler: (passIndex, evt) ->
    if $(@target).hasClass('drag-handle') or $(@target).parents('.drag-handle').length > 0
      evt.dataTransfer.setData 'passIndex', passIndex
    else
      evt.preventDefault()
  dropHandler: (passIndex, evt) ->
    sourceIndex = evt.dataTransfer.getData 'passIndex'
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.REORDER_PASS
      jamId: @props.jam.id
      sourcePassIndex: sourceIndex
      targetPassIndex: passIndex
  createNextPass: () ->
    AppDispatcher.dispatchAndEmit
      type: ActionTypes.CREATE_NEXT_PASS
      jamId: @props.jam.id
      passId: functions.uniqueId()
  render: () ->
    <div className="passes">
      <div className="headers">
        <div className="row gutters-xs">
          <div className="col-sm-11 col-xs-11 col-sm-offset-1 col-xs-offset-1">
            <div className="col-sm-2 col-xs-2">
              Pass
            </div>
            <div className="col-sm-2 col-xs-2">
              Skater
            </div>
            <div className="col-sm-2 col-xs-2"></div>
            <div className="col-sm-2 col-xs-2 text-center">
              Notes
            </div>
            <div className="col-sm-2 col-xs-2"></div>
            <div className="col-sm-2 col-xs-2 text-center">
              Points
            </div>
          </div>
        </div>
      </div>
      <div className="columns">
        {@props.jam.passes.map (pass, passIndex) ->
          <PassItem
            key={passIndex}
            pass={pass}
            jam={@props.jam}
            setSelectorContext={@props.setSelectorContext}
            dragHandler={@dragHandler.bind(this, passIndex)}
            dropHandler={@dropHandler.bind(this, passIndex)}
            mouseDownHandler={@mouseDownHandler} />
        , this}
      </div>
      <div className="actions">
        <div className="row gutters-xs">
          <div className="col-sm-12 col-xs-12">
            <button className="bt-btn action" onClick={@createNextPass}>Next Pass</button>
          </div>
        </div>
      </div>
    </div>
