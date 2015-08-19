React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'LineupSelector'
  propTypes:
    team: React.PropTypes.object
    jam: React.PropTypes.object
    selectHandler: React.PropTypes.func
  isSelected: (position, skater) ->
    @props?.jam?[position]?.id is skater.id
  getStyle: (position, skater) ->
    if @isSelected(position, skater)
      @props.team.colorBarStyle
  btnClass: (skater) -> cx
    'bt-btn': true
    'btn-danger': skater.fouledOut() or skater.expelled()
    'btn-injury': @props.team.skaterIsInjured(skater.id, @props.jam.jamNumber)
  render: () ->
    <div className="modal" id="lineup-selector-modal">
      <div className="modal-dialog lineup-selector-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal"><span>&times;</span></button>
            <h4 className="modal-title">Select Lineup</h4>
          </div>
          <div className="modal-body">
            <div className="row gutters-xs">
              {@props.jam?.listPositionLabels()?.map (pos) ->
                <div key={pos} className="col-xs-5-cols text-center">
                  <strong>{pos}</strong>
                </div>
              , this}
            </div>
            <div className="row gutters-xs">
              {@props.jam?.listPositions()?.map (position) ->
                <div key={position} className='col-xs-5-cols'>
                  {@props.team?.skaters?.map (skater, skaterIndex) ->
                    <button key={skaterIndex}
                      className={@btnClass(skater)}
                      style={@getStyle(position, skater)}
                      onClick={@props.selectHandler.bind(null, position, skater.id)}>
                        <strong className="skater-number">{skater.number}</strong>
                    </button>
                  , this}
                </div>
              , this}
            </div>
          </div>
        </div>
      </div>
    </div>