require 'rails_helper'

RSpec.describe 'user registration page' do
  before(:each) do
    visit '/register'
  end

  it 'has a form to create a new user' do
    fill_in 'user_username', with: 'Jeff33'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button('Register')
    user = User.last

    expect(current_path).to eq('/dashboard')
    expect(user.username).to eq('Jeff33')
  end

  it 'links to google registration' do
    expect(page).to have_link('Register with Google')
  end

  it 'can create a user with google_oauth2/omniauth' do
    visit '/auth/google_oauth2/callback'
    user = User.last

    expect(current_path).to eq('/dashboard')
  end
end
