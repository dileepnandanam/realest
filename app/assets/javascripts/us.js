$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.message-us-form-link', function(e) {
    $(this).closest('.message-form-container').html(e.detail[2].responseText)
  })

  var sections = $.map($('.section'), function(e, i) {return(e)})

  iterate = function(sections, i) {
    if(i == sections.length)
      return
    $(sections[i]).show(100)
    setTimeout(function(){iterate(sections, i+1)}, 100)
  }
  iterate(sections, 0)
})