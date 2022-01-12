require 'rails_helper'

RSpec.describe "Merchant Items Show Page" do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Parker")
    @merchant_2 = Merchant.create!(name: "Kerri")
    @item1 = @merchant_1.items.create!(name: "Small Thing", description: "Its a thing that is small.", unit_price: 40000)
    @item2 = @merchant_1.items.create!(name: "Large Thing", description: "Its a thing that is large.", unit_price: 80000)
    @item3 = @merchant_2.items.create!(name: "Medium Thing", description: "Its a thing that is medium.", unit_price: 60000)
    visit "/merchants/#{@merchant_1.id}/items/#{@item1.id}"
  end

  it 'shows the item name, description, current selling price' do

    expect(page).to have_content("#{@item1.name}")
    expect(page).to have_content("Description: #{@item1.description}")
    expect(page).to have_content("Current Price: $400.00")
    expect(page).to_not have_content("#{@item2.name}")
    expect(page).to_not have_content("Description: #{@item2.description}")
    expect(page).to_not have_content("Current Price: $800.00")
    expect(page).to_not have_content("#{@item3.name}")
    expect(page).to_not have_content("Description: #{@item3.description}")
    expect(page).to_not have_content("Current Price: $600.00")
  end
end
