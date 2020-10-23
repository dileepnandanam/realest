class NotificationJob < ApplicationJob
  def perform(message, path, user_id)
    ApplicationCable::NotificationsChannel.broadcast_to(
      User.find(user_id),
      "<a class='notification' href=#{path}>#{message}</a>"
    )
  end
end