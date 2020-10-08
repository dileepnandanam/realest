class NotifGenerator
  def self.new_properties
    Property.where(state: 'new').count
  end

  def self.new_cars
    Car.where(state: 'new').count
  end

  def self.new_interests
    Property.joins(:users).where('properties_users.seen = false').count
  end
end