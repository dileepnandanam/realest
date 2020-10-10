class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Office < Property
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price, :area) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates
  

  validates_with PlaceValidator

  def self.search(state, price_range, coordinates)
    sql = Office
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    if coordinates.present?
      sql = sql.near(coordinates, 10)
    end
    sql
  end

  PLACES = File.open('places.txt', 'r').read.split("\n")
end
