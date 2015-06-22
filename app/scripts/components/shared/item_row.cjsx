React = require 'react/addons'
cx = React.addons.classSet
$ = require 'jquery'
module.exports = React.createClass
  displayName: 'ItemRow'
  propTypes:
    item: React.PropTypes.node.isRequired
    removeHandler: React.PropTypes.func.isRequired
    panel: React.PropTypes.node
    index: React.PropTypes.number
    reorderHandler: React.PropTypes.func
  getInitialState: () ->
    opened: false
  preventDefault: (evt) ->
    evt.preventDefault()
  mouseDownHandler: (evt) ->
    @target = evt.target
  dragHandler: (evt) ->
    if @props.reorderHandler? and @props.index?
      if $(@target).hasClass('drag-handle') or $(@target).parents('.drag-handle').length > 0
        evt.dataTransfer.setData 'passIndex', @props.index
      else
        evt.preventDefault()
  dropHandler: (evt) ->
    if @props.reorderHandler? and @props.index?
      sourceIndex = evt.dataTransfer.getData 'passIndex'
      @props.reorderHandler(sourceIndex, @props.index)
  removeHandler: () ->
    if window.confirm("Do you really want to remove this item? This action cannot be undone and affects other interfaces")
      @props.removeHandler()
  toggleOpened: () ->
    @setState(opened: not @state.opened)
  render: () ->
    containerClass = cx
      'item-row': true
      'opened': @state.opened
    handleClass = cx
      'bt-btn options-button': true
      'drag-handle': @props.reorderHandler? and @props.index?
    <div className={containerClass}
      aria-multiselectable="true"
      draggable={@props.reorderHandler? and @props.index?}
      onDragStart={@dragHandler}
      onDragOver={@preventDefault}
      onDrop={@dropHandler}
      onMouseDown={@mouseDownHandler}>
      <div className="row gutters-xs top-buffer">
        <div className="col-xs-1">
          <button className={handleClass} onClick={@toggleOpened}>
            <span className="glyphicon glyphicon-option-horizontal" />
          </button>
        </div>
        <div className="col-xs-11">
          <div className="item">
            {@props.item}
            <div className="options bt-box box-selected">
              <div className="row gutters-xs">
                <div className="col-xs-2 col-xs-offset-5">
                  <button className="bt-btn" onClick={@removeHandler}>
                    <span className="glyphicon glyphicon-trash"></span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      {@props.panel if @props.panel?}
    </div>
