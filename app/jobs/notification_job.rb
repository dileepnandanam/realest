class NotificationJob < ApplicationJob
  def perform(message, user_id)
    ApplicationCable::NotificationsChannel.broadcast_to(
      User.find(user_id),
      message
    )
  end
end