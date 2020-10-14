class Servent < Property

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:expected_price) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates


  def self.search(state, price_range, coordinates)
    sql = Servent
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    if coordinates.present?
      sql = sql.near(coordinates, 10)
    end
    sql
  end

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