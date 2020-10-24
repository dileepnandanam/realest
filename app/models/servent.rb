class Servent < Property

  validates_each(:expected_price) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates

  def summary
    "#{servent} for hire at #{place}"
  end

  def present
    {
      "expected salery" => expected_price,
      "place" => place
    }
  end

  def set_suggestion
    self.suggestion = "servent near #{place}"
  end

  def common_tags
    ' kerala servent home keeper house '
  end

end