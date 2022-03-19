require 'rails_helper'

RSpec.describe 'New Merchant Form Page' do
  let!(:user) { create(:user) }

  before(:each) do
    visit '/login'
    fill_in 'username', with: user.username
    fill_in 'password', with: 'password123'
    click_button('Log In')
    visit '/merchants/new'
  end

  it 'can create new merchant' do
    fill_in 'merchant_name', with: 'The Little Yarn Shop'
    click_button('Submit')

    expect(current_path).to eq('/merchants/dashboard')
  end

  it 'shows error if merchant form not filled' do
    click_button('Submit')

    expect(current_path).to eq('/merchants/new')
    expect(page).to have_content('Error: Something went wrong.')
  end 
end
