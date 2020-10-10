class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class House < Property
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user


  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price, :landmark) do |record, attr, value|
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

  def self.search(state, price_range, coordinates)
    sql = House
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    if coordinates.present?
      sql = sql.near(coordinates, 20)
    end
    sql
  end

  PLACES = File.open('places.txt', 'r').read.split("\n")
end