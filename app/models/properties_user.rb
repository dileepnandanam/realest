class PropertiesUser < ApplicationRecord
  belongs_to :property
  belongs_to :land, class_name: 'Land', foreign_key: :property_id, optional: true
  belongs_to :car, class_name: 'Car', foreign_key: :property_id, optional: true
  belongs_to :servent, class_name: 'Servent', foreign_key: :property_id, optional: true
  belongs_to :house, class_name: 'House', foreign_key: :property_id, optional: true
  belongs_to :user
end
