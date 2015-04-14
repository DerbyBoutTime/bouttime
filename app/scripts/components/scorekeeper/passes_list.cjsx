React = require 'react/addons'
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
  render: () ->
    PassItemFactory = React.createFactory(PassItem)
    passComponents = @props.jam.getPasses().map (pass, passIndex) =>
      PassItemFactory(
        key: passIndex
        jam: @props.jam
        pass: pass
        setSelectorContext: @props.setSelectorContext
        dragHandler: @dragHandler.bind(this, passIndex)
        dropHandler: @dropHandler.bind(this, passIndex)
        mouseDownHandler: @mouseDownHandler
      )
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
      {passComponents}
    </div>
