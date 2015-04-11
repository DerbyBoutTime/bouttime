cx = React.addons.classSet
exports = exports ? this
exports.JamTimer = React.createClass
  displayName: 'JamTimer'
  getInitialState: () ->
    modalHandler: () ->
  handleToggleTimeoutBar: (evt) ->
    $target = $(evt.target)
    $parent = $target.closest(".timeout-bars").first()
    if $target.hasClass "official-review"
      if $target.hasClass "inactive"
        #Set has official review to true
        #Increment official reviews retained
        if $parent.hasClass "home"
          @props.manager.restoreHomeTeamOfficialReview()
        else
          @props.manager.restoreAwayTeamOfficialReview()
      else
        #Set has official review to false
        if $parent.hasClass "home"
          @props.manager.removeHomeTeamOfficialReview()
        else
          @props.manager.removeAwayTeamOfficialReview()
    else #Its a normal timeout not an official review
      timeoutsRemaining = 0
      if $target.hasClass "inactive"
        timeoutsRemaining = timeoutsRemaining + 1
      timeoutsRemaining = timeoutsRemaining + $target.nextAll(".bar").length
      console.log "Setting remaining timeouts to #{timeoutsRemaining}"
      #Set remaining timeouts
      if $parent.hasClass "home"
        @props.manager.setHomeTeamTimeouts(timeoutsRemaining)
      else
        @props.manager.setAwayTeamTimeouts(timeoutsRemaining)
    return null
  openModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $modal.modal('show')
  handleModal: () ->
    $modal = $(@refs.modal.getDOMNode())
    $input = $(@refs.modalInput.getDOMNode())
    $modal.modal('hide')
    val = parseInt($input.val())
    @state.modalHandler(val)
  clickJamEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.jamNumber)
    @openModal()
    @setState
      modalHandler: @props.manager.setJamNumber
  clickPeriodEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.periodNumber)
    @openModal()
    @setState
      modalHandler: @props.manager.setPeriodNumber
  clickJamClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.jamClockAttributes.time/1000)
    @openModal()
    @setState
      modalHandler: @props.manager.setJamClock
  clickPeriodClockEdit: () ->
    $input = $(@refs.modalInput.getDOMNode())
    $input.val(@props.periodClockAttributes.time/1000)
    @openModal()
    @setState
      modalHandler: @props.manager.setPeriodClock
  render: () ->
    #CS = Class Set
    timeoutSectionCS = cx
      'timeout-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["jam", "lineup", "timeout", "unofficial_final"]) == -1
    timeoutExplanationSectionCS = cx
      'timeout-explanation-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["timeout"]) == -1
    undoSectionCS = cx
      'undo-section': true
      'row': true
      'margin-xs': true
      'hidden': true #$.inArray(@props.state, ["jam", "lineup", "timeout", "unofficial_final", "final"]) == -1
    startClockSectionCS = cx
      'start-clock-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["pregame", "halftime", "final"]) == -1
    stopClockSectionCS = cx
      'stop-clock-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["pregame"]) == -1
    startJamSectionCS = cx
      'start-jam-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["pregame", "halftime", "lineup"]) == -1
    stopJamSectionCS = cx
      'stop-jam-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["jam"]) == -1
    startLineupSectionCS = cx
      'start-lineup-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["pregame", "halftime",  "timeout", "unofficial_final", "final"]) == -1
    jamExplanationSectionCS = cx
      'jam-explanation-section': true
      'row': true
      'margin-xs': true
      'hidden': $.inArray(@props.state, ["lineup", "timeout", "unofficial_final"]) == -1
    homeTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @props.homeAttributes.isTakingOfficialReview
      'inactive': @props.homeAttributes.hasOfficialReview == false
    homeTeamTimeouts1CS = cx
      'bar': true
      'active': @props.homeAttributes.isTakingTimeout && @props.homeAttributes.timeouts == 2
      'inactive': @props.homeAttributes.timeouts < 3
    homeTeamTimeouts2CS = cx
      'bar': true
      'active': @props.homeAttributes.isTakingTimeout && @props.homeAttributes.timeouts == 1
      'inactive': @props.homeAttributes.timeouts < 2
    homeTeamTimeouts3CS = cx
      'bar': true
      'active': @props.homeAttributes.isTakingTimeout && @props.homeAttributes.timeouts == 0
      'inactive': @props.homeAttributes.timeouts < 1
    awayTeamOfficialReviewCS = cx
      'official-review': true
      'bar': true
      'active': @props.awayAttributes.isTakingOfficialReview
      'inactive': @props.awayAttributes.hasOfficialReview == false
    awayTeamTimeouts1CS = cx
      'bar': true
      'active': @props.awayAttributes.isTakingTimeout && @props.awayAttributes.timeouts == 2
      'inactive': @props.awayAttributes.timeouts < 3
    awayTeamTimeouts2CS = cx
      'bar': true
      'active': @props.awayAttributes.isTakingTimeout && @props.awayAttributes.timeouts == 1
      'inactive': @props.awayAttributes.timeouts < 2
    awayTeamTimeouts3CS = cx
      'bar': true
      'active': @props.awayAttributes.isTakingTimeout && @props.awayAttributes.timeouts == 0
      'inactive': @props.awayAttributes.timeouts < 1
    <div className="jam-timer">
        <div className="row text-center">
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars home">
              <span className="jt-label">{@props.homeAttributes.initials}</span>
              <div className={homeTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@props.homeAttributes.officialReviewsRetained}</div>
              <div className={homeTeamTimeouts1CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={homeTeamTimeouts2CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={homeTeamTimeouts3CS} onClick={@handleToggleTimeoutBar}></div>
            </div>
          </div>
          <div className="col-md-8 col-xs-8">
            <div className="row">
              <div className="col-xs-12">
                <strong>
                  <span className="jt-label pull-left" onClick={@clickPeriodEdit}>
                    Period {@props.periodNumber}
                  </span>
                  <span className="jt-label pull-right" onClick={@clickJamEdit}>
                    Jam {@props.jamNumber}
                  </span>
                </strong>
              </div>
              <div className="col-md-12 col-xs-12">
                <div className="period-clock" onClick={@clickPeriodClockEdit}>{@props.periodClockAttributes.display}</div>
              </div>
              <div className="col-md-12 col-xs-12">
                <strong className="jt-label">{@props.state.replace(/_/g, ' ')}</strong>
                <div className="jam-clock" onClick={@clickJamClockEdit}>{@props.jamClockAttributes.display}</div>
              </div>
            </div>
          </div>
          <div className="col-md-2 col-xs-2">
            <div className="timeout-bars away">
              <span className="jt-label">{@props.awayAttributes.initials}</span>
              <div className={awayTeamOfficialReviewCS} onClick={@handleToggleTimeoutBar}>{@props.awayAttributes.officialReviewsRetained}</div>
              <div className={awayTeamTimeouts1CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={awayTeamTimeouts2CS} onClick={@handleToggleTimeoutBar}></div>
              <div className={awayTeamTimeouts3CS} onClick={@handleToggleTimeoutBar}></div>
            </div>
          </div>
        </div>
        <div className={timeoutSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@props.manager.startTimeout}>TIMEOUT</button>
          </div>
        </div>
        <div className={timeoutExplanationSectionCS}>
          <div className="col-xs-4">
            <div className="home">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@props.manager.setTimeoutAsHomeTeamTimeout}>TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@props.manager.setTimeoutAsHomeTeamOfficialReview}>
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-md-4 col-xs-4">
            <button className="bt-btn" onClick={@props.manager.setTimeoutAsOfficialTimeout}>
              <div>OFFICIAL</div>
              <div>TIMEOUT</div>
            </button>
          </div>
          <div className="col-md-4 col-xs-4 timeouts">
            <div className="away">
              <div className="row">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@props.manager.setTimeoutAsAwayTeamTimeout}>TIMEOUT</button>
                </div>
              </div>
              <div className="row margin-xs">
                <div className="col-md-12 col-xs-12">
                  <button className="bt-btn" onClick={@props.manager.setTimeoutAsAwayTeamOfficialReview}>
                    <span className="hidden-xs">OFFICIAL REVIEW</span>
                    <span className="visible-xs-inline">REVIEW</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className={undoSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn undo-btn">UNDO</button>
          </div>
        </div>
        <div className={startClockSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@props.manager.startClock}>START CLOCK</button>
          </div>
        </div>
        <div className={stopClockSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@props.manager.stopClock}>STOP CLOCK</button>
          </div>
        </div>
        <div className={startJamSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@props.manager.startJam}>START JAM</button>
          </div>
        </div>
        <div className={stopJamSectionCS}>
          <div className="col-xs-12">
            <button className="bt-btn" onClick={@props.manager.stopJam}>STOP JAM</button>
          </div>
        </div>
        <div className={startLineupSectionCS}>
          <div className="col-xs-12 start-lineup-section">
            <button className="bt-btn" onClick={@props.manager.stopJam}>START LINEUP</button>
          </div>
        </div>
        <div className={jamExplanationSectionCS}>
          <div className="col-xs-6">
            <button className="bt-btn" onClick={@props.manager.setJamEndedByCalloff}>
              JAM CALLED
            </button>
          </div>
          <div className="col-xs-6">
            <button className="bt-btn" onClick={@props.manager.setJamEndedByTime}>
              ENDED BY TIME
            </button>
          </div>
        </div>
        <div className="modal" ref="modal">
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="modal-header">
                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 className="modal-title">Edit</h4>
              </div>
              <div className="modal-body">
                <input type="number" className="form-control" ref="modalInput"/>
              </div>
              <div className="modal-footer">
                <button type="button" className="btn btn-primary" onClick={@handleModal}>Save changes</button>
              </div>
            </div>
          </div>
        </div>
    </div>