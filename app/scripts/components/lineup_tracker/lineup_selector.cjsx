React = require 'react/addons'
cx = React.addons.classSet
GameState = require '../../models/game_state'
module.exports = React.createClass
  displayName: 'LineupSelector'
  propTypes:
    team: React.PropTypes.object
    jam: React.PropTypes.object
    selectHandler: React.PropTypes.func
  getInitialState: () ->
    jammer: @props.jam?.jammer?.id
    pivot: @props.jam?.pivot?.id
    blocker1: @props.jam?.blocker1?.id
    blocker2: @props.jam?.blocker2?.id
    blocker3: @props.jam?.blocker3?.id
  isSelected: (position, skater) ->
    @state[position] is skater.id
  selectHandler: (position, skaterId) ->
    @state[position] = skaterId
    @props.selectHandler(position, skaterId)
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
                      onClick={@selectHandler.bind(null, position, skater.id)}>
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