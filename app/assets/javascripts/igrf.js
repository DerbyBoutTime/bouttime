$(function () {
  $('[data-toggle="tooltip"]').tooltip();
  $("#igrf_import_form").fileinput({ 'allowedFileExtensions': ['xlsx'], 'elErrorContainer': '#fileinput-error', 'showPreview': false, 'showUpload': false });
})
