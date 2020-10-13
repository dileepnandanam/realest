class NotifGenerator
  def self.counts(controller_name)
    controller_name.singularize.camelize.constantize.group(:state).count('distinct id')
  end

  def self.new_interests
    Property.joins(:users).where('properties_users.seen = false').count
  end

  def self.interest_counts(controller_name)
    controller_name.singularize.camelize.constantize
      .where(state: 'approved')
      .joins('inner join properties_users on properties_users.property_id = properties.id')
      .count('distinct properties_users.id')
  end
end