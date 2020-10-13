class PlaceValidator < ActiveModel::Validator
  def validate(record)
    if record.lat.blank?
      record.errors[:place] << 'unrecognized'
    end
  end
end
class Property < ApplicationRecord
  has_one_attached :img1
  has_many :property_assets

  belongs_to :user
  has_and_belongs_to_many :users

  has_many :properties_user, foreign_key: :property_id

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank? && record.type == nil
      record.errors.add(attr, 'must be given')
    end
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates
  def set_coordinates
    result = GeocoderValues::MAP[self.place]
    if result.first.present?
      coordinates = result
      self.lat = coordinates[0]
      self.lngt = coordinates[1]
    end
  end

  validates_with PlaceValidator

  def self.search(state, price_range, acre_range, coordinates)
    sql = Property
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where(total_cents: acre_range)
    if coordinates.present?
      sql = sql.near(coordinates, 50)
    end
    sql
  end

  before_save :calculate_total_cents
  def calculate_total_cents
    if type == nil
      self.total_cents = acre * 100 + cent
    end
  end

  before_save :set_index
  before_save :set_suggestion

  def set_index
    self.index = summary.downcase
  end


  def self.search_query(query)
    terms = query.split(/[\., ;'"?]/)
    terms = terms.select{|t| !STOP_WORDS.include?(t)}.map(&:downcase)
    if terms.length == 0
      return Property.where('0=1')
    end
    select_query = terms.map{|t| "(COALESCE(index LIKE '%#{t}%', FALSE))::int"}.join('+')
    result_ids = ApplicationRecord.connection.execute("select matches.id from (select #{select_query} match_count, id from properties where properties.state = 'approved') matches where matches.match_count = #{terms.length}").map{|ar| ar['id']}
    Property.where(id: result_ids)
  end

  STOP_WORDS = ['near', 'away', 'ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 'am', 'or', 'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being', 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than']

end
