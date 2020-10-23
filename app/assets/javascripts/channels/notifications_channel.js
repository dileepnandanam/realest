create_notification_subscribed = null
$(document).on('turbolinks:load', function() {
  audio = new Audio($('.response-notif').attr('src'));
  
  if(create_notification_subscribed == null) {
    App.cable.subscriptions.create("ApplicationCable::NotificationsChannel", {
      received(data) {
        $('.notifications').append(data)
        audio.play()
      }
    })
    create_notification_subscribed = 1
  }
})