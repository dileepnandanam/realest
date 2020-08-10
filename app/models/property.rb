class Property < ApplicationRecord
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user
  has_and_belongs_to_many :users

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end

  def self.search(state, price_range, acre_range)
    sql = Property
    sql = sql.where(state: state)
    sql = sql.where(expected_price: price_range)
    sql = sql.where(land_mass: acre_range)
  end

  before_save :calculate_land_mass
  def calculate_land_mass
    self.land_mass = "#{acre}.#{cent}".to_f
  end
end
