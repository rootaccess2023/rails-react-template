class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :trackable

  # Validations
  validates :first_name, :last_name, presence: true
  validates :authentication_token, uniqueness: true, allow_nil: true

  # Callbacks
  before_save :ensure_authentication_token

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def generate_authentication_token!
    loop do
      token = Devise.friendly_token
      break token unless User.exists?(authentication_token: token)
    end
  end
  
  def token_expired?
    token_expires_at && token_expires_at < Time.current
  end
  
  def refresh_token!
    self.authentication_token = generate_authentication_token!
    self.token_expires_at = 24.hours.from_now
    save!
  end
  
  private
  
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token!
      self.token_expires_at = 24.hours.from_now
    end
  end
end
