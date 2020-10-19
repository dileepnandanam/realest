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

  has_and_belongs_to_many :users, primery_key: :property_id, foreign_key: :user_id

  has_many :properties_user, foreign_key: :property_id

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank? && record.type == nil
      record.errors.add(attr, 'must be given')
    end
  end

  def self.search(params)
    sql = self
    sql = sql.where(state: params[:state]) if params[:state].present?
    sql = sql.where(expected_price: params[:price_range]) if params[:price_range].present?
    sql = sql.where(area: params[:area_range]) if params[:area_range].present?
    sql = sql.where(total_cents: params[:acre_range]) if params[:acre_range].present?
    sql = sql.near(params[:coordinates], 15) if params[:coordinates].present?
    sql
  end


  reverse_geocoded_by :lat, :lngt
  before_validation :set_coordinates
  def set_coordinates
    result = GeocoderValues::ALL_PLACES[self.place]
    if result.present?
      coordinates = result
      self.lat = coordinates[0]
      self.lngt = coordinates[1]
    end
  end

  validates_with PlaceValidator


  before_save :set_index
  before_save :set_suggestion

  def set_index
    self.index = summary.downcase + common_tags + tags.to_s + visible_caption.to_s
    self.index = self.index.split(/[\., ;'"?]/).map(&:singularize).join(' ')
  end

  def self.search_query(query)
    terms = query.split(/[\., ;'"?]/).map(&:singularize)
    terms = terms.select{|t| !STOP_WORDS.include?(t)}.map(&:downcase)
    if terms.length == 0
      return Property.where('0=1')
    end
    select_query = terms.map{|t| "(COALESCE(index LIKE '%#{t}%', FALSE))::int"}.join('+')
    result_ids = ApplicationRecord.connection.execute("select matches.id from (select #{select_query} match_count, id from properties where properties.state = 'approved') matches where matches.match_count::float > #{terms.length/2} ORDER BY matches.match_count DESC").map{|ar| ar['id']}
    Property.where(id: result_ids)
  end

  STOP_WORDS = ['near', 'away', 'ourselves', 'hers', 'between', 'yourself', 'but', 'again', 'there', 'about', 'once', 'during', 'out', 'very', 'having', 'with', 'they', 'own', 'an', 'be', 'some', 'for', 'do', 'its', 'yours', 'such', 'into', 'of', 'most', 'itself', 'other', 'off', 'is', 'am', 'or', 'who', 'as', 'from', 'him', 'each', 'the', 'themselves', 'until', 'below', 'are', 'we', 'these', 'your', 'his', 'through', 'don', 'nor', 'me', 'were', 'her', 'more', 'himself', 'this', 'down', 'should', 'our', 'their', 'while', 'above', 'both', 'up', 'to', 'ours', 'had', 'she', 'all', 'no', 'when', 'at', 'any', 'before', 'them', 'same', 'and', 'been', 'have', 'in', 'will', 'on', 'does', 'yourselves', 'then', 'that', 'because', 'what', 'over', 'why', 'so', 'can', 'did', 'not', 'now', 'under', 'he', 'you', 'herself', 'has', 'just', 'where', 'too', 'only', 'myself', 'which', 'those', 'i', 'after', 'few', 'whom', 't', 'being', 'if', 'theirs', 'my', 'against', 'a', 'by', 'doing', 'it', 'how', 'further', 'was', 'here', 'than']

end
