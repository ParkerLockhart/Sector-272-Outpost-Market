class User < ApplicationRecord
  has_many :merchant_users
  has_many :merchants, through: :merchant_users
  
  validates :username, presence: true
  validates :username, uniqueness: true
  enum role: [:default, :manager, :admin]

  has_secure_password

  def self.find_or_create_by_auth(auth_data)
    # user = self.find_or_create_by username: auth_data[:info][:email]
    if self.find_by username: auth_data[:info][:email]
      user = self.find_by username: auth_data[:info][:email]
    else
      user = self.create(username: auth_data[:info][:email], password: SecureRandom.base64(10))
    end
  end
end
