require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe 'secure user creation' do
    it 'saves user auth info securely' do
      user = User.create(username: "Jeff33", password: "password", password_confirmation: "password")
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq("password")
    end
  end 
end
