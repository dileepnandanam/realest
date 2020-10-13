class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class House < Property
  has_one_attached :img1

  belongs_to :user


  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price, :landmark, :area) do |record, attr, value|
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

  def self.search(state, price_range, area_range, coordinates)
    sql = House
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where(area: area_range)
    if coordinates.present?
      sql = sql.near(coordinates, 10)
    end
    sql
  end

  def present
    {
      "expected rent" => expected_price,
      "place" => place,
      "area" => "#{area} square feets",
      "landmark" => landmark
    }
  end

  def summary
    "#{area} square feet house at #{place}"
  end

  def set_suggestion
    self.suggestion = "house at #{place}"
  end

  def common_tags
    ' kerala house home veed small big stay appartmrnt apartment appartment flat '
  end
end