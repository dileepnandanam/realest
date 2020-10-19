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

  def present
    {
      "expected price" => expected_price,
      "place" => place,
      "brand" => "#{model} model #{brand}"
    }
  end



  def summary
    "#{model} #{brand} at #{place}"
  end

  def set_suggestion
    self.suggestion = "car near #{place}"
  end

  def common_tags
    'kerala car vehicle vehicil'
  end
end
