exports = exports ? this
cx = React.addons.classSet
exports.SkaterSelector = React.createClass
  displayName: 'SkaterSelector'
  propTypes:
    skater: React.PropTypes.object
    style: React.PropTypes.object
    injured: React.PropTypes.bool
    setSelectorContext: React.PropTypes.func
    selectHandler: React.PropTypes.func
    placeholder: React.PropTypes.string
  buttonContent: () ->
    if @props.skater
      @props.skater.number
    else
      <strong>{@props.placeholder}<span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span></strong>
  render: () ->
    injuryClass = cx
      'skater-injury': @props.injured
    <button
      className={injuryClass + " skater-selector text-center bt-btn"}
      data-toggle="modal"
      style={if @props.skater and not @props.injured then @props.style else {}}
      data-target="#skater-selector-modal"
      onClick={@props.setSelectorContext.bind(this, @props.selectHandler)}>
      <strong>{@buttonContent()}</strong>
    </button>
exports.SkaterSelectorModal = React.createClass
  displayName: 'SkaterSelectorModal'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    jamState: React.PropTypes.object.isRequired
    selectHandler: React.PropTypes.func
  getLineup: () ->
    jam = @props.jamState
    positions = [jam.pivot, jam.blocker1, jam.blocker2, jam.blocker3, jam.jammer]
    positions.filter (position) ->
      position?
  inLineup: (skater) ->
    skater.number in @getLineup().map (s) -> s.number
  isInjured: (skater) ->
    false
  buttonClass: (skater) ->
    cx
      'selector-injury' : @isInjured(skater)
      'bt-btn skater-selector-dialog-btn': true
  render: () ->
    <div className="modal fade" id="skater-selector-modal">
      <div className="modal-dialog skater-selector-dialog">
        <div className="modal-content">
          <div className="modal-header">
            <button type="button" className="close" data-dismiss="modal"><span>&times;</span></button>
            <h4 className="modal-title">Select Skater</h4>
          </div>
          <div className="modal-body">
            {@props.teamState.skaterStates.map (skaterState, skaterIndex) ->
                <button key={skaterIndex}
                  className={@buttonClass(skaterState)}
                  style={if @inLineup(skaterState.skater) and not @isInjured(skaterState.skater) then @props.teamState.colorBarStyle}
                  data-dismiss="modal"
                  onClick={@props.selectHandler.bind(this, skaterIndex)}>
                    <strong className="skater-number">{skaterState.skater.number}</strong>
                    <strong className="skater-name">{skaterState.skater.name}</strong>
                </button>
            , this}
          </div>
        </div>
      </div>
    </div>