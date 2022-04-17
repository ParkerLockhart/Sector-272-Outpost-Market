require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:merchant) }
    it { should validate_numericality_of(:unit_price) }
    it { should define_enum_for(:status).with_values(disabled: 0,enabled: 1) }
  end

  describe "relationships" do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'instance methods' do
    describe '#best_day' do
      it 'shows the day on which an item generated the most revenue' do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)

        item_1 = create(:item, merchant: merchant_1, status: 1)
        item_2 = create(:item, merchant: merchant_1)
        item_3 = create(:item, merchant: merchant_1)
        item_4 = create(:item, merchant: merchant_1)
        item_5 = create(:item, merchant: merchant_2)
        item_6 = create(:item, merchant: merchant_2)
        item_7 = create(:item, merchant: merchant_1)
        item_8 = create(:item, merchant: merchant_1)

        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)
        customer_4 = create(:customer)
        customer_5 = create(:customer)
        customer_6 = create(:customer)

        invoice_1 = create(:invoice, customer: customer_1, status: 2,  created_at: "2012-03-27 14:54:09")
        invoice_2 = create(:invoice, customer: customer_1, status: 2,  created_at: "2012-03-28 14:54:09")
        invoice_3 = create(:invoice, customer: customer_2, status: 2)
        invoice_4 = create(:invoice, customer: customer_3, status: 2)
        invoice_5 = create(:invoice, customer: customer_4, status: 2)
        invoice_6 = create(:invoice, customer: customer_5, status: 2)
        invoice_7 = create(:invoice, customer: customer_6, status: 1)

        ii_1 = create(:invoice_item, invoice: invoice_1, item: item_1, calculated_price: 10, quantity: 9, status: 2, created_at: "2012-03-27 14:54:09")
        ii_2 = create(:invoice_item, invoice: invoice_2, item: item_1, calculated_price: 10, quantity: 9, status: 2, created_at: "2012-03-28 14:54:09")
        ii_3 = create(:invoice_item, invoice: invoice_3, item: item_2, calculated_price: 8, quantity: 2, status: 2)
        ii_4 = create(:invoice_item, invoice: invoice_4, item: item_3, calculated_price: 5, quantity: 3, status: 1)
        ii_6 = create(:invoice_item, invoice: invoice_5, item: item_4, calculated_price: 1, quantity: 1, status: 1)
        ii_7 = create(:invoice_item, invoice: invoice_6, item: item_7, calculated_price: 3, quantity: 1, status: 1)
        ii_8 = create(:invoice_item, invoice: invoice_7, item: item_8, calculated_price: 5, quantity: 1, status: 1)
        ii_9 = create(:invoice_item, invoice: invoice_7, item: item_4, calculated_price: 1, quantity: 1, status: 1)

        transaction1 = create(:transaction, result: 1, invoice: invoice_1)
        transaction2 = create(:transaction, result: 1, invoice: invoice_2)
        transaction3 = create(:transaction, result: 1, invoice: invoice_3)
        transaction4 = create(:transaction, result: 1, invoice: invoice_4)
        transaction5 = create(:transaction, result: 1, invoice: invoice_5)
        transaction6 = create(:transaction, result: 0, invoice: invoice_6)
        transaction7 = create(:transaction, result: 1, invoice: invoice_7)

        expect(item_1.best_day).to eq(invoice_2.created_at)
      end
    end
  end
end
