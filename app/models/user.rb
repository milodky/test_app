class User < ActiveRecord::Base
  has_many :microposts
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  before_save { self.email = email.downcase }
  validates :password, length: { minimum: 6 }
  # this method is introduced by bcrypt, which acts as a call back function
  has_secure_password
end
