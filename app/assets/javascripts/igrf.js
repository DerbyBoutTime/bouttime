$(function () {
  $('[data-toggle="tooltip"]').tooltip();
  $("#interleague_game_reporting_form_form").fileinput({ 'allowedFileExtensions': ['xlsx'], 'elErrorContainer': '#fileinput-error', 'showPreview': false, 'showUpload': false });
})
