class Message < ApplicationRecord
  validates :contact, presence: true
  validates :content, presence: true
  validates :name, presence: true
end
