class PropertiesUser < ApplicationRecord
  belongs_to :property
  belongs_to :car, class_name: 'Car', foreign_key: :property_id
  belongs_to :car, class_name: 'Servent', foreign_key: :property_id
  belongs_to :car, class_name: 'House', foreign_key: :property_id
  belongs_to :user
end
