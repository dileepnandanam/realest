accept_notification_subscribed = null
$(document).on('turbolinks:load', function() {
  audio = new Audio($('.response-notif').attr('src'));
  
  if(accept_notification_subscribed == null) {
    App.cable.subscriptions.create("ApplicationCable::AcceptNotificationsChannel", {
      received(data) {
        audio.play()
        $('.nav').append(data.message)
      }
    })
    accept_notification_subscribed = 1
  }
})