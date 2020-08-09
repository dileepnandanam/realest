class Property < ApplicationRecord
  has_one_attached :img1
  has_one_attached :img2
  has_one_attached :img3
  has_one_attached :img4

  belongs_to :user

  #validates :img1, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
  validates_each(:acre, :cent, :expected_price, :landmark) do |record, attr, value|
    if value.blank?
      record.errors.add(attr, 'must be given')
    end
  end

  def self.search(query, price_range, acre_range, cent_range)
    sql = Property
    if query.present?
      sql = sql.where("landmark like '%#{query}%'")
    end

    if price_range.present?
      sql = sql.where(expected_price: price_range)
    end

    if acre_range.present?
      sql = sql.where(acre: acre_range)
    else
      sql = sql.where(acre: [0, nil])
    end

    if cent_range.present?
      sql = sql.where(cent: cent_range)
    end 
  end
end
