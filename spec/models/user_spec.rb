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

  describe 'class methods' do
    describe 'find_or_create_by_auth' do
      it 'returns user registered or logged in via oauth' do
        auth_data = {info: {email: "jeff@email.com"}}

        user = User.find_or_create_by_auth(auth_data)

        expect(user).to be_instance_of(User)
        expect(user.username).to eq("jeff@email.com")
      end
    end
  end
end
