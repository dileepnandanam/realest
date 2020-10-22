class Office < House


  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price, :area) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates


  def present
    {
      "expected rent" => expected_price,
      "place" => place,
      "area" => "#{area.to_i} square feets",
      "landmark" => landmark
    }
  end

  def summary
    "#{area} square feet office space at #{place}"
  end

  def set_suggestion
    self.suggestion = "office at #{place}"
  end

  def common_tags
    ' kerala office workplace workspace space rend company officeroom room'
  end
end
