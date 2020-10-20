class House < Property

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price, :landmark, :area) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end

  def present
    {
      "expected price" => expected_price,
      "place" => place,
      "area" => "#{area} square feet",
      "landmark" => landmark
    }
  end

  def summary
    "#{area} square feet house at #{place}"
  end

  def set_suggestion
    self.suggestion = "house for sale at #{place}"
  end

  def common_tags
    ' kerala house home veed stay '
  end
end