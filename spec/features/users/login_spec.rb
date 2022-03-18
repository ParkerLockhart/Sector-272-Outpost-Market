require 'rails_helper'

RSpec.describe 'login page' do
  before(:each) do
    visit '/login'
  end
  let!(:user) { create(:user) }

  it 'redirects user to dashboard if authenticated' do
    fill_in 'username', with: user.username
    fill_in 'password', with: 'password123'
    click_button("Log In")

    expect(current_path).to eq('/dashboard')
  end

  it 'does not allow access to dashboard if auth fails' do
    fill_in 'username', with: user.username
    fill_in 'password', with: 'password124'
    click_button("Log In")

    expect(current_path).to eq('/login')
    expect(page).to have_content("Error: Unable to authenticate user. Please try again.")
  end

  it 'does not allow access to dashboard if user not found' do
    fill_in 'username', with: 'whatever'
    fill_in 'password', with: 'password123'
    click_button("Log In")

    expect(current_path).to eq('/login')
    expect(page).to have_content("Error: Unable to authenticate user. Please try again, or register if new user.")
  end

  it 'has a link to log in with google' do
    expect(page).to have_link('Login with Google')
  end
end 
