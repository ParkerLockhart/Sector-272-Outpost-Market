class User < ApplicationRecord
  validates :username, presence: true
  validates :username, uniqueness: true
  enum role: [:default, :manager, :admin]

  has_secure_password

  def self.find_or_create_by_auth(auth_data)
    user = self.find_or_create_by username: auth_data["info"]["email"]
  end
end
