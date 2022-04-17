require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to(:customer) }
    it { should belong_to(:merchant)}
  end

  describe "validations" do
    it { should validate_presence_of(:customer) }
    it { should validate_presence_of(:merchant) }
    it { should validate_presence_of(:status) }
  end

  describe 'instance methods' do
    let!(:customer) { create(:customer, first_name: "Cookie", last_name: "Monster") }
    let!(:merchant_1) { create(:merchant) }
    let!(:invoice_1) { create(:invoice, customer: customer, merchant: merchant_1, created_at: Date.today) }
    let!(:invoice_2) { create(:invoice) }
    let!(:item_1) { create(:item, status: "enabled", unit_price: 1000, merchant: merchant_1) }
    let!(:item_2) { create(:item, unit_price: 2000, merchant: merchant_1) }
    let!(:invoice_item_1) { create(:invoice_item, invoice: invoice_1, item: item_1, status: "pending", quantity: 5, calculated_price: item_1.unit_price) }
    let!(:invoice_item_2) { create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 10, calculated_price: item_2.unit_price) }
    let!(:discount) { create(:discount, merchant: merchant_1, amount: 10, threshold: 10) }

    describe '#pretty_created_at' do
      it 'formats created_at datetime' do
        expect(invoice_1.pretty_created_at).to eq(Date.today.strftime("%A, %B %-d, %Y"))
      end
    end

    describe '#customer_name' do
      it 'outputs customer full name' do
        expect(invoice_1.customer_name).to eq("Cookie Monster")
      end
    end

    describe '#items_info' do
      it 'shows invoice items with order info' do
        first = invoice_1.items_info.first
        expect(first.name).to eq(item_1.name)
        expect(first.quantity).to eq(invoice_item_1.quantity)
        expect(first.status).to eq(invoice_item_1.status)
      end
    end

    describe '#order_total' do
      it 'calculates total for invoice' do
        expect(invoice_1.order_total).to eq(25000)
      end
    end

    describe '#total_with_discount' do
      # need to change how discounts work after moving from float to integer cents
      xit 'calculates total revenue minus applicable discounts' do
        expect(invoice_1.total_with_discount).to eq(230)
      end
    end
  end
end
