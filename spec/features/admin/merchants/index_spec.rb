require 'rails_helper'

RSpec.describe 'admin merchants index' do
  let!(:merchant_1) {FactoryBot.create(:merchant, status: "disabled")}
  let!(:merchant_2) {FactoryBot.create(:merchant, status: "enabled")}
  let!(:merchant_3) {FactoryBot.create(:merchant, status: "enabled")}
  let!(:merchant_4) {FactoryBot.create(:merchant, status: "disabled")}
  before(:each) do
    visit '/admin/merchants'
  end

  it 'shows the name of all merchants' do
    expect(page).to have_content(merchant_1.name)
    expect(page).to have_content(merchant_2.name)
    expect(page).to have_content(merchant_3.name)
    expect(page).to have_content(merchant_4.name)
  end

  it 'can enable a merchant' do
    expect(merchant_1.status).to eq("disabled")
    within("#disabled-merchants") do
      within("#admin-merchant-#{merchant_1.id}") do
        click_button("Enable")
        expect(current_path).to eq("/admin/merchants")
      end
    end
    within("#enabled-merchants") do
      within("#admin-merchant-#{merchant_1.id}") do
        expect(page).to have_button("Disable")
      end
    end
  end

  it 'can disable a merchant' do
    expect(merchant_2.status).to eq("enabled")
    within("#enabled-merchants") do
      within("#admin-merchant-#{merchant_2.id}") do
        click_button("Disable")
        expect(current_path).to eq("/admin/merchants")
      end
    end
    within("#disabled-merchants") do
      within("#admin-merchant-#{merchant_2.id}") do
        expect(page).to have_button("Enable")
      end
    end
  end

  it 'has a section for enabled merchants' do
    within("#enabled-merchants") do
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
      expect(page).to_not have_content(merchant_1.name)
      expect(page).to_not have_content(merchant_4.name)
    end
  end

  it 'has a section for disabled merchants' do
    within("#disabled-merchants") do
      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_4.name)
      expect(page).to_not have_content(merchant_2.name)
      expect(page).to_not have_content(merchant_3.name)
    end
  end

  it 'has a link to create a new merchant on a new page' do
    expect(page).to have_link("Create a New Merchant", href: "/admin/merchants/new")
  end

  describe 'Top 5 Merchants Section' do
    let!(:invoice_item_1) {FactoryBot.create(:invoice_item, quantity: 1, unit_price: 10)}
    let!(:invoice_item_2) {FactoryBot.create(:invoice_item, quantity: 2, unit_price: 10)}
    let!(:invoice_item_3) {FactoryBot.create(:invoice_item, quantity: 3, unit_price: 10)}
    let!(:invoice_item_4) {FactoryBot.create(:invoice_item, quantity: 4, unit_price: 10)}
    let!(:invoice_item_5) {FactoryBot.create(:invoice_item, quantity: 5, unit_price: 10)}
    let!(:invoice_item_6) {FactoryBot.create(:invoice_item, quantity: 6, unit_price: 10)}
    let!(:invoice_item_7) {FactoryBot.create(:invoice_item, quantity: 7, unit_price: 10)}

    it 'has a section for the top five merchants by total revenue' do
      expect(page).to have_content("Top Five Merchants By Revenue")
    end

    it 'has the names of each of the top 5 merchants' do
      expect(invoice_item_7.item.merchant).to appear_before(invoice_item_6.item.merchant)
      expect(invoice_item_6.item.merchant).to appear_before(invoice_item_5.item.merchant)
      expect(invoice_item_5.item.merchant).to appear_before(invoice_item_4.item.merchant)
      expect(invoice_item_4.item.merchant).to appear_before(invoice_item_3.item.merchant)
    end
  end
end
