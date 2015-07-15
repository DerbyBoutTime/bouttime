React = require 'react/addons'
module.exports = React.createClass
  displayName: 'LineupSelector'
  propTypes:
    team: React.PropTypes.object
    jam: React.PropTypes.object
    selectHandler: React.PropTypes.func
  isSelected: (position, skater) ->
    @props?.jam?[position]?.id is skater.id
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
              <div className="col-xs-5-cols text-center">
                <strong>J</strong>
              </div>
              <div className="col-xs-5-cols text-center">
                <strong>P</strong>
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
            </div>
            <div className="row gutters-xs">
              {['jammer', 'pivot', 'blocker1', 'blocker2', 'blocker3'].map (position) ->
                <div key={position} className='col-xs-5-cols'>
                  {@props.team?.skaters?.map (skater, skaterIndex) ->
                    <button key={skaterIndex}
                      className='bt-btn lineup-selector-dialog-btn': true
                      style={if @isSelected(position, skater) then @props.team.colorBarStyle}
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