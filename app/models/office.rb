class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Office < Property


  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price, :area) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates
  

  validates_with PlaceValidator

  def self.search(state, price_range, area_range, coordinates)
    sql = Office
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
      "area" => "#{area.to_i} square feets",
      "landmark" => landmark
    }
  end

  def summary
    "#{area} sqr ft office space at #{place}"
  end
end
