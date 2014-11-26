exports = exports ? this

exports.wftda.functions.scorekeeperChange = () ->
  toggle = (show, hide) ->
    $('#' + show + '-team').removeClass('hidden-xs')
    $('#' + hide + '-team').addClass('hidden-xs')

    $('.active-team .' + show).removeClass('hidden-xs')
    $('.active-team .' + hide).addClass('hidden-xs')

  $('.team-name').click ->
    if $(this).hasClass('away')
      toggle('away', 'home')
    else
      toggle('home', 'away')

    return

$(document).on("page:change", exports.wftda.functions.scorekeeperChange)
