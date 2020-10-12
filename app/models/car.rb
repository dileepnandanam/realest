class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Car < Property
  has_one_attached :img1

  belongs_to :user

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates


  validates_with PlaceValidator

  def self.search(state, price_range, model, brand, coordinates)
    sql = Car
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where('model::INT >= ?', model.to_i) if model.present?
    sql = sql.where('lower(brand) = ?', brand.downcase) if brand.present?

    if coordinates.present?
      sql = sql.near(coordinates, 10)
    end
    sql
  end

  def present
    {
      "expected price" => expected_price,
      "place" => place,
      "brand" => "#{model} model #{brand}"
    }
  end

  def summary
    "#{model} #{brand}"
  end
end
