require 'rails_helper'

RSpec.describe 'user dashboard' do

  it 'does not allow access with out user auth' do
    visit '/dashboard'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('You must be logged in to access this page.')
  end

  it 'has link to logout authorized user' do
    user = create(:user)
    visit '/login'
    fill_in 'username', with: user.username
    fill_in 'password', with: 'password123'
    click_button('Log In')

    expect(current_path).to eq('/dashboard')
    expect(page).to have_link('logout')
    click_link('logout')
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Successfully logged out')
  end
end
