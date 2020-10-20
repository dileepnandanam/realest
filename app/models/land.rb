class Land < Property

  belongs_to :user
  has_and_belongs_to_many :users, primery_key: :property_id, foreign_key: :user_id

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates

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

  def summary
    acre1 = acre.to_i > 0 ? "#{acre} acre" : nil
    cent1 = cent.to_i > 0 ? "#{cent} cent" : nil
    [acre1, cent1, "land at #{place}"].select(&:present?).join(' ')
  end

  def set_suggestion
    self.suggestion = "land at #{place}"
  end

  def common_tags
    ' kerala land plot ploat place acre property properties '
  end

end
