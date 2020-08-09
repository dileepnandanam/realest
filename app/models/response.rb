class Response < ApplicationRecord
  has_one :from_user, class_name: 'User', primary_key: :from_user_id, foreign_key: :id
end
