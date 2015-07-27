class User < ActiveRecord::Base
  # normalizes the emails saved to the database
  before_save {self.email.downcase!}
  
  # validates the presence and length of the name string
  validates :name, presence: true, length: {maximum: 50}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  # because we are using emails as user name we need to validate their uniqueness
  validates :email, presence: true, length: {maximum: 255},
                          format: {with: VALID_EMAIL_REGEX},
                          uniqueness: {case_sensitive: false}

  has_secure_password

  validates :password, presence: true, length: {minimum: 6}


  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
