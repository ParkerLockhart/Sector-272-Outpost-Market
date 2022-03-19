require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do
  let!(:user) { create(:user, role: 1) }

  let!(:merchant_1) { create(:merchant, status: "disabled")}

  let!(:merchant_user) { create(:merchant_user, merchant: merchant_1, user: user) }

  let!(:item_1) { create(:item, merchant_id: merchant_1.id, status: 0) }

  let!(:transaction_1) { create(:transaction, result: "success")}

  let!(:invoice_item_1) { create(:invoice_item, invoice_id: transaction_1.invoice.id, item_id: item_1.id, quantity: 1, unit_price: 10) }


  before(:each) do
    visit '/login'
    fill_in 'username', with: user.username
    fill_in 'password', with: 'password123'
    click_button('Log In')
    VCR.insert_cassette('upcoming_holidays')
    visit '/merchants/dashboard'
  end

  after(:each) do
    VCR.eject_cassette('upcoming_holidays')
  end

  it 'shows the merchants name' do
    expect(page).to have_content(merchant_1.name)
  end

  it 'links to merchant items index' do
    click_link("Items")
    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")
  end

  it 'links to merchant invoices index' do
    click_link("Invoices")
    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices")
  end

  it 'has a section for Items Ready to Ship' do
    expect(page).to have_content("Items Ready To Ship")
  end

  it 'has a link to view current discounts offered' do
    click_link("Discounts")
    expect(current_path).to eq("/merchants/#{merchant_1.id}/discounts")
  end

  it 'has a link back to main user dashboard' do
    click_link('Back to main dashboard')
    expect(current_path).to eq('/dashboard')
  end 
end
