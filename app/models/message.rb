class Message < ApplicationRecord
  validates :contact, presence: true
  validates :content, presence: true
end
