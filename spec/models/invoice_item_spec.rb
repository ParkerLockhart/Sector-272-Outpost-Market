require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of(:item) }
    it { should validate_presence_of(:invoice) }
    it { should validate_presence_of(:status)}
    it { should validate_numericality_of(:quantity) }
  end

  describe "relationships" do
    it { should belong_to(:item) }
    it { should belong_to(:invoice) }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:discounts).through(:merchant) }
  end

  describe "class methods" do
    let!(:merchant_1) { create(:merchant) }
    let!(:customer_1) { create(:customer) }
    let!(:customer_2) { create(:customer) }
    let!(:customer_3) { create(:customer) }
    let!(:customer_4) { create(:customer) }
    let!(:customer_5) { create(:customer) }
    let!(:customer_6) { create(:customer) }
    let!(:item_1) { create(:item, merchant: merchant_1) }
    let!(:item_2) { create(:item, merchant: merchant_1) }
    let!(:item_3) { create(:item, merchant: merchant_1) }
    let!(:invoice_1) { create(:invoice, customer: customer_1, merchant: merchant_1, status: 0) }
    let!(:invoice_2) { create(:invoice, customer: customer_1, merchant: merchant_1, status: 1) }
    let!(:invoice_3) { create(:invoice, customer: customer_2, merchant: merchant_1, status: 0) }
    let!(:invoice_4) { create(:invoice, customer: customer_3, merchant: merchant_1, status: 1) }
    let!(:invoice_5) { create(:invoice, customer: customer_4, merchant: merchant_1, status: 1) }
    let!(:ii_1) { create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, calculated_price: 10, status: 0) }
    let!(:ii_2) { create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 1, calculated_price: 10, status: 0) }
    let!(:ii_3) { create(:invoice_item, invoice: invoice_2, item: item_3, quantity: 1, calculated_price: 10, status: 2) }
    let!(:ii_4) { create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 1, calculated_price: 10, status: 1) }

    describe 'incomplete_invoices' do
      it 'returns invoices with pending status' do
        expect(InvoiceItem.incomplete_invoices).to eq([invoice_1, invoice_3])
      end
    end
  end

  describe 'instance methods' do
    let!(:merchant) { create(:merchant) }

    let!(:discount_1) { create(:discount, merchant: merchant, amount: 10, threshold: 10) }
    let!(:discount_2) { create(:discount, merchant: merchant, amount: 20, threshold: 20) }

    let!(:item) { create(:item, unit_price: 100, merchant: merchant)}
    let!(:invoice) { create(:invoice) }
    let!(:ii) { create(:invoice_item, calculated_price: 100, invoice: invoice, item: item, quantity: 15)}

    describe 'applicable_discount' do
      it 'calculates amount of discount that applies' do
        expect(ii.applicable_discount).to eq(discount_1)
        expect(ii.applicable_discount).to_not eq(discount_2)
      end
    end

    describe 'item_total' do
      it 'returns line total of each invoice_item calculated price and quantity' do
        expect(ii.item_total).to eq(1500)
      end
    end

    describe 'discounted_total' do
      it 'returns total for invoice_item with applicable discounts' do
        expect(ii.discounted_total).to eq(1350)
      end
    end
  end

end
