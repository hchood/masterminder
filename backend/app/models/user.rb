class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email,
    presence: true,
    uniqueness: true
  validates :password, presence: true
  validates :access_token, uniqueness: true

  before_validation :set_access_token, on: :create

  private

  def set_access_token
    return if access_token.present?

    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: self.access_token)
  end
end
