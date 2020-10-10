class NotifGenerator
  def self.counts(controller_name)
    controller_name.singularize.camelize.constantize.group(:state).count('distinct id')
  end

  def self.new_interests
    Property.joins(:users).where('properties_users.seen = false').count
  end
end