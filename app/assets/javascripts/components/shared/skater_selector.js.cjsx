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
  buttonContent: () ->
    if this.props.skater
      this.props.skater.number
    else
      <span className="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
  render: () ->
    injuryClass = cx
      'skater-injury': this.props.injured
    <button
      className={injuryClass + " skater-selector text-center bt-btn"}
      data-toggle="modal"
      style={if this.props.skater and not this.props.injured then this.props.style else {}}
      data-target="#skater-selector-modal"
      onClick={this.props.setSelectorContext.bind(this, this.props.selectHandler)}>
      <strong>{this.buttonContent()}</strong>
    </button>
exports.SkaterSelectorModal = React.createClass
  displayName: 'SkaterSelectorModal'
  propTypes:
    teamState: React.PropTypes.object.isRequired
    jamState: React.PropTypes.object.isRequired
    selectHandler: React.PropTypes.func
  getLineup: () ->
    jam = this.props.jamState
    positions = [jam.pivot, jam.blocker1, jam.blocker2, jam.blocker3, jam.jammer]
    positions.filter (position) ->
      position?
  inLineup: (skater) ->
    skater.number in this.getLineup().map (s) -> s.number
  isInjured: (skater) ->
    false
  buttonClass: (skater) ->
    cx
      'selector-injury' : this.isInjured(skater)
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
            {this.props.teamState.skaterStates.map (skaterState, skaterIndex) ->
                <button key={skaterIndex}
                  className={this.buttonClass(skaterState)}
                  style={if this.inLineup(skaterState.skater) and not this.isInjured(skaterState.skater) then this.props.teamState.colorBarStyle}
                  data-dismiss="modal"
                  onClick={this.props.selectHandler.bind(this, skaterIndex)}>
                    <strong className="skater-number">{skaterState.skater.number}</strong>
                    <strong className="skater-name">{skaterState.skater.name}</strong>
                </button>
            , this}
          </div>
        </div>
      </div>
    </div>