class User < ActiveRecord::Base
  attr_accessor :remember_token
  has_many :microposts
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  before_save { self.email = email.downcase }
  validates :password, length: { minimum: 6 }
  # this method is introduced by bcrypt, which acts as a call back function
  has_secure_password


  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # so basically we're gonna store this value
  # and the remote app user can also store this value
  # then the next time we can compare the app user's
  # token with the one which we store in the database
  # if they're the same, we regard they as the same
  # person, otherwise we redirect the request to login
  # or homepage
  # thus the permanent connection is implemented unless
  # the app user clears his cookie
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = self.class.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if self.remember_digest.blank?
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
