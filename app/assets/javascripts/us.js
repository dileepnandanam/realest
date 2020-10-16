$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.message-us-form-link', function(e) {
    $(this).closest('.message-form-container').html(e.detail[2].responseText)
  })
})