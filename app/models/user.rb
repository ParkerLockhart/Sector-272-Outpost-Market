class User < ApplicationRecord
  validates :username, presence: true
  validates :username, uniqueness: true
  enum role: [:default, :manager, :admin]

  has_secure_password
end
