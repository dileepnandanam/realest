$(document).on('turbolinks:load', function() {
  search = function() {
    $.ajax({
      url: '/properties?' + $('.filter-form').serialize(),
      dataType: 'html',
      success: function(data) {
        $('.properties').html(data)
      }
    })
  }

  $('.filter-field').on('keyup', search)


  $(document).on('ajax:success', '.property-action-link', function(e) {
    $(this).closest('.property-action').replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.more-interests-link', function(e) {
    $('.more-interests-link').replaceWith(e.detail[2].responseText)
  })
})