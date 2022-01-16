require 'rails_helper'

RSpec.describe 'discount new page' do
  let!(:merchant) {FactoryBot.create(:merchant)}

  before(:each) do
    visit "/merchants/#{merchant.id}/discounts/new"
  end

  it 'can create a new discount' do
    fill_in 'amount', with: 0.1
    fill_in 'threshold', with: 10
    click_button 'Submit'

    expect(current_path).to eq("/merchants/#{merchant.id}/discounts")
    expect(page).to have_content("10% off of 10 or more items")
  end
end