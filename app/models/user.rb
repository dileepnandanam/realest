class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable
  has_one_attached :img
  has_and_belongs_to_many :properties
  has_many :owned_properties, class_name: 'Property', foreign_key: :user_id

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :contact_number, presence: true

  validates_format_of :email,:with => Devise::email_regexp

  def new_password
    new_p = "abcdefghijklmnopqrstuvwxyz1234567890".split('').sample(6).join
    self.password = new_p
    self.password_confirmation = new_p
    self.save
    new_p
  end
end
