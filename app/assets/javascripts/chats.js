$(document).on('turbolinks:load', function() {
  bind_chat = function() {
    $(document).on('ajax:success', '.chat-box', function(e) {
      $(document).off('ajax:success', '.chat-box')
      $('.chat-thread').append(e.detail[2].responseText)
      $(this).find('textarea').val('')
      scroll_to_bottom()
      bind_chat()
    })
  }
  bind_chat()

  scroll_to_bottom = function() {
    $('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))
  }
  $('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))

  $('.chat-box').on('keypress', 'textarea', function(e) {
    if(e.which == 13)
      Rails.fire($(this).closest('form')[0], 'submit')
  })
})