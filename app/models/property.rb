class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Property < ApplicationRecord
  attr_accessor :place
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user
  has_and_belongs_to_many :users

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates
  def set_coordinates
    result = Geocoder.search(self.place)
    if result.first.present?
      coordinates = result.first.coordinates
      self.lat = coordinates[0]
      self.lngt = coordinates[1]
    end
  end

  validates_with PlaceValidator

  def self.search(state, price_range, acre_range, coordinates)
    sql = Property
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where(land_mass: acre_range)
    if coordinates.present?
      sql = sql.near(coordinates, 50)
    end
  end

  before_save :calculate_land_mass
  def calculate_land_mass
    self.land_mass = "#{acre}.#{cent}".to_f
  end
end
