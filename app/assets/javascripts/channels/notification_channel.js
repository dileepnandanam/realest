create_notification_subscribed = null
$(document).on('turbolinks:load', function() {
  audio = new Audio($('.response-notif').attr('src'));
  
  if(create_notification_subscribed == null) {
    App.cable.subscriptions.create("ApplicationCable::NotificationChannel", {
      received(data) {
        audio.play()
        $('.response-tab').css('background', 'red')
      }
    })
    create_notification_subscribed = 1
  }
})