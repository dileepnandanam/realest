class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Land < Property
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user
  has_and_belongs_to_many :users, primery_key: :property_id, foreign_key: :user_id

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank? && record.type == nil
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates

  validates_with PlaceValidator

  def self.search(state, price_range, acre_range, coordinates)
    sql = Land
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where(total_cents: acre_range)
    if coordinates.present?
      sql = sql.near(coordinates, 10)
    end
    sql
  end

  before_save :calculate_total_cents
  def calculate_total_cents
    self.total_cents = acre.to_i * 100 + cent.to_i
  end

  def present
    {
      "expected price" => expected_price,
      "place" => place,
      "area" => "#{acre.to_i} acre #{cent.to_i} cent",
      "landmark" => landmark
    }
  end
end
