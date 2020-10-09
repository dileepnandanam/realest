class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Car < Property
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user
  has_and_belongs_to_many :users, primary_key: :property_id, foreign_key: :user_id

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price) do |record, attr, value|
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

  def self.search(state, price_range, model, brand, coordinates)
    sql = Car
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where('model::INT >= ?', model.to_i) if model.present?
    sql = sql.where('lower(brand) = ?', brand.downcase) if brand.present?

    if coordinates.present?
      sql = sql.near(coordinates, 50)
    end
    sql
  end

  PLACES = File.open('places.txt', 'r').read.split("\n")
end
