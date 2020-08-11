class NotifGenerator
  def self.new_properties
    Property.where(seen: false).count
  end

  def self.new_interests
    Property.joins(:users).where('properties_users.seen = false').count
  end
end