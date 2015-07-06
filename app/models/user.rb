class User < ActiveRecord::Base
  attr_accessor :remember_token, :activation_token, :reset_token

  ###############################################################
  ##############  below are all business logic ##################
  ###############################################################

  # Here the option dependent: :destroy arranges for the dependent
  # microposts to be destroyed when the user itself is destroyed
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  # Rails allows us to override the default, in this case using the source parameter,
  # which explicitly tells Rails that the source of the following array is the set of
  # followed ids.
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower





  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  before_save { self.email = email.downcase }
  validates :password, length: { minimum: 6 }, allow_nil: true
  before_create :create_activation_digest
  # this method is introduced by bcrypt, which acts as a call back function
  # it also includes a separate presence validation on object creation.
  has_secure_password

  # Returns the hash digest of the given string.
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
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
    update_attribute(:remember_digest, self.digest(self.remember_token))
  end

  # Returns true if the given token matches the digest.
  # it will authenticate either a persistent connection (by remember_digest)
  # or an activation of a new user (by activation_digest)
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")

    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end



  # for test purpose only
  def new_record?
    super
  end


  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = self.class.new_token
    self.activation_digest = self.class.digest(activation_token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns a user's status feed.
  def feed
    Micropost.where("user_id IN (?) OR user_id = ?", self.following_ids, self.id)
  end

end
