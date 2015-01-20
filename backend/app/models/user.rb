class User < ActiveRecord::Base
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email,
    presence: true,
    uniqueness: true
  validates :access_token, uniqueness: true

  before_validation :set_access_token, on: :create

  def self.from_request(request)
    return unless request.authorization

    bearer_token = request.authorization.gsub(/\ABearer /, '')
    find_by(access_token: bearer_token)
  end

  private

  def set_access_token
    return if access_token.present?

    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: self.access_token)
  end
end
