exports = exports ? this

exports.wftda.functions.scorekeeperChange = () ->
  $('.team-name').click ->
    $('#away-team, #home-team, .active-team .away, .active-team .home').toggleClass('hidden-xs')

    return

$(document).on("page:change", exports.wftda.functions.scorekeeperChange)
