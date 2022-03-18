require 'rails_helper'

RSpec.describe 'Welcome Page' do
  before(:each) do
    visit '/'
  end

  it 'links to register page' do
    expect(page).to have_link('Register as new user')
    click_link('Register as new user')
    expect(current_path).to eq('/register')
  end

  it 'links to login page' do
    expect(page).to have_link('Login')
    click_link('Login')
    expect(current_path).to eq('/login')
  end
end
