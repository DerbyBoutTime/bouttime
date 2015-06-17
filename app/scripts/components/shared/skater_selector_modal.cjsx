React = require 'react/addons'
cx = React.addons.classSet
module.exports = React.createClass
  displayName: 'SkaterSelectorModal'
  propTypes:
    team: React.PropTypes.object
    jam: React.PropTypes.object
    selectHandler: React.PropTypes.func
  getLineup: () ->
    jam = @props.jam
    positions = [jam.pivot, jam.blocker1, jam.blocker2, jam.blocker3, jam.jammer]
    positions.filter (position) ->
      position?
  inLineup: (skater) ->
    if @props.jam?
      skater.number in @getLineup().map (s) -> s.number
    else
      false
  isInjured: (skater) ->
    false
  buttonClass: (skater) ->
    cx
      'selector-injury' : @isInjured(skater)
      'bt-btn skater-selector-dialog-btn': true
  render: () ->
    <div className="modal" id="skater-selector-modal">
      <div className="modal-dialog skater-selector-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal"><span>&times;</span></button>
            <h4 className="modal-title">Select Skater</h4>
          </div>
          <div className="modal-body">
            {@props.team?.skaters?.map (skater, skaterIndex) ->
                <button key={skaterIndex}
                  className={@buttonClass(skater)}
                  style={if @inLineup(skater) and not @isInjured(skater) then @props.team.colorBarStyle}
                  data-dismiss="modal"
                  onClick={@props.selectHandler.bind(null, skater.id)}>
                    <strong className="skater-number">{skater.number}</strong>
                    <strong className="skater-name">{skater.name}</strong>
                </button>
            , this}
          </div>
        </div>
      </div>
    </div>