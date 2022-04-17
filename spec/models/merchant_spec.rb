require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "relationships" do
    it { should have_many(:items) }
    it { should have_many(:discounts) }
    it { should have_many(:invoices) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:merchant_users) }
    it { should have_many(:users).through(:merchant_users) }
  end

  describe 'class methods' do
    let!(:merchant_1) { create(:merchant, status: "disabled") }
    let!(:merchant_2) { create(:merchant, status: "enabled") }
    let!(:merchant_3) { create(:merchant, status: "enabled") }
    let!(:merchant_4) { create(:merchant, status: "disabled") }
    let!(:merchant_5) { create(:merchant) }
    let!(:merchant_6) { create(:merchant) }
    let!(:merchant_7) { create(:merchant) }

    let!(:item_1) { create(:item, merchant: merchant_1, status: 0) }
    let!(:item_2) { create(:item, merchant: merchant_2, status: 1) }
    let!(:item_3) { create(:item, merchant: merchant_3) }
    let!(:item_4) { create(:item, merchant: merchant_4) }
    let!(:item_5) { create(:item, merchant: merchant_5) }
    let!(:item_6) { create(:item, merchant: merchant_6) }
    let!(:item_7) { create(:item, merchant: merchant_7) }

    let!(:invoice_1) { create(:invoice, status: 1, merchant: merchant_1) }
    let!(:invoice_2) { create(:invoice, status: 1, merchant: merchant_2) }
    let!(:invoice_3) { create(:invoice, status: 1, merchant: merchant_3) }
    let!(:invoice_4) { create(:invoice, status: 1, merchant: merchant_4) }
    let!(:invoice_5) { create(:invoice, status: 1, merchant: merchant_5) }
    let!(:invoice_6) { create(:invoice, status: 1, merchant: merchant_6) }
    let!(:invoice_7) { create(:invoice, status: 1, merchant: merchant_7) }

    let!(:transaction_1) { create(:transaction, invoice: invoice_1, result: "success") }
    let!(:transaction_2) { create(:transaction, invoice: invoice_2, result: "success") }
    let!(:transaction_3) { create(:transaction, invoice: invoice_3, result: "success") }
    let!(:transaction_4) { create(:transaction, invoice: invoice_4, result: "success") }
    let!(:transaction_5) { create(:transaction, invoice: invoice_5, result: "success") }
    let!(:transaction_6) { create(:transaction, invoice: invoice_6, result: "success") }
    let!(:transaction_7) { create(:transaction, invoice: invoice_7, result: "success") }

    let!(:ii_1) { create(:invoice_item, invoice: invoice_1, calculated_price: 10, item: item_1, quantity: 1) }
    let!(:ii_2) { create(:invoice_item, invoice: invoice_2, calculated_price: 10, item: item_2, quantity: 2) }
    let!(:ii_3) { create(:invoice_item, invoice: invoice_3, calculated_price: 10, item: item_3, quantity: 3) }
    let!(:ii_4) { create(:invoice_item, invoice: invoice_4, calculated_price: 10, item: item_4, quantity: 4) }
    let!(:ii_5) { create(:invoice_item, invoice: invoice_5, calculated_price: 10, item: item_5, quantity: 5) }
    let!(:ii_6) { create(:invoice_item, invoice: invoice_6, calculated_price: 10, item: item_6, quantity: 6) }
    let!(:ii_7) { create(:invoice_item, invoice: invoice_7, calculated_price: 10, item: item_7, quantity: 7) }

    describe '::top_merchants' do
      it 'returns the top five merchants by revenue' do
        invoice_1.update(total: invoice_1.order_total)
        invoice_2.update(total: invoice_2.order_total)
        invoice_3.update(total: invoice_3.order_total)
        invoice_4.update(total: invoice_4.order_total)
        invoice_5.update(total: invoice_5.order_total)
        invoice_6.update(total: invoice_6.order_total)
        invoice_7.update(total: invoice_7.order_total)

        merchants = [merchant_7, merchant_6, merchant_5, merchant_4, merchant_3]

        expect(Merchant.top_merchants).to eq(merchants)
      end
    end

    describe '::filter_merchant_status'
      it 'returns merchants based on status' do
        expect(Merchant.filter_merchant_status(0)).to include(merchant_1)
        expect(Merchant.filter_merchant_status(1)).to include(merchant_2)
      end
    end
  end

  describe 'instance methods' do
    let!(:merchant_1) { create(:merchant) }
    let!(:merchant_2) { create(:merchant) }
    let!(:merchant_3) { create(:merchant) }
    let!(:item_1) { create(:item, status: 1, merchant: merchant_1) }
    let!(:item_2) { create(:item, merchant: merchant_1) }
    let!(:item_3) { create(:item, status: 1, merchant: merchant_1) }
    let!(:item_4) { create(:item, merchant: merchant_1) }
    let!(:item_5) { create(:item, merchant: merchant_2) }
    let!(:item_6) { create(:item, merchant: merchant_3) }
    let!(:item_7) { create(:item, merchant: merchant_1) }
    let!(:item_8) { create(:item, merchant: merchant_1) }
    let!(:customer_1) { create(:customer) }
    let!(:customer_2) { create(:customer) }
    let!(:customer_3) { create(:customer) }
    let!(:customer_4) { create(:customer) }
    let!(:customer_5) { create(:customer) }
    let!(:customer_6) { create(:customer) }
    let!(:invoice_1) { create(:invoice, merchant: merchant_1, customer: customer_1, status: 1) }
    let!(:invoice_2) { create(:invoice, merchant: merchant_1, customer: customer_1, status: 1) }
    let!(:invoice_3) { create(:invoice, merchant: merchant_1, customer: customer_2, status: 1) }
    let!(:invoice_4) { create(:invoice, merchant: merchant_1, customer: customer_3, status: 1) }
    let!(:invoice_5) { create(:invoice, merchant: merchant_1, customer: customer_4, status: 1) }
    let!(:invoice_6) { create(:invoice, merchant: merchant_1, customer: customer_5, status: 1) }
    let!(:invoice_7) { create(:invoice, merchant: merchant_1, customer: customer_6, status: 1) }
    let!(:invoice_8) { create(:invoice, merchant: merchant_1, customer: customer_6, status: 2) }
    let!(:ii_1) { create(:invoice_item, invoice: invoice_1, item: item_1, calculated_price: 10, quantity: 9) }
    let!(:ii_2) { create(:invoice_item, invoice: invoice_2, item: item_1, calculated_price: 10, quantity: 1) }
    let!(:ii_3) { create(:invoice_item, invoice: invoice_3, item: item_2, calculated_price: 12, quantity: 2, status: 2) }
    let!(:ii_4) { create(:invoice_item, invoice: invoice_4, item: item_3, calculated_price: 10, quantity: 4, status: 1) }
    let!(:ii_5) { create(:invoice_item, invoice: invoice_5, item: item_4, calculated_price: 10, quantity: 1, status: 1) }
    let!(:ii_6) { create(:invoice_item, invoice: invoice_6, item: item_7, calculated_price: 10, quantity: 1, status: 1) }
    let!(:ii_7) { create(:invoice_item, invoice: invoice_7, item: item_8, calculated_price: 10, quantity: 1, status: 1) }
    let!(:ii_8) { create(:invoice_item, invoice: invoice_7, item: item_4, calculated_price: 10, quantity: 1, status: 1) }
    let!(:ii_9) { create(:invoice_item, invoice: invoice_8, item: item_4, calculated_price: 10, quantity: 1, status: 1) }
    let!(:trans_1) { create(:transaction, invoice: invoice_1, result: 1) }
    let!(:trans_2) { create(:transaction, invoice: invoice_2, result: 1) }
    let!(:trans_3) { create(:transaction, invoice: invoice_3, result: 1) }
    let!(:trans_4) { create(:transaction, invoice: invoice_4, result: 1) }
    let!(:trans_5) { create(:transaction, invoice: invoice_5, result: 1) }
    let!(:trans_6) { create(:transaction, invoice: invoice_6, result: 0) }
    let!(:trans_7) { create(:transaction, invoice: invoice_7, result: 1) }
    let!(:trans_8) { create(:transaction, invoice: invoice_8, result: 1) }

    describe '#top_customers' do
      # currently inexplicably still including invoices that were cancelled
      xit 'returns the top 5 customers for a merchant' do
        invoice_1.update(total: invoice_1.order_total)
        invoice_2.update(total: invoice_2.order_total)
        invoice_3.update(total: invoice_3.order_total)
        invoice_4.update(total: invoice_4.order_total)
        invoice_5.update(total: invoice_5.order_total)
        invoice_6.update(total: invoice_6.order_total)
        invoice_7.update(total: invoice_7.order_total)
        invoice_8.update(total: invoice_8.order_total)

        customers = [customer_1, customer_3, customer_2, customer_6, customer_4]
        expect(merchant_1.top_customers).to eq(customers)
      end
    end

    describe '#ready_items' do
      #on the list to be reworked to provide ready items per invoice
      xit 'returns the items which have not yet shipped' do
        expect(merchant_1.ready_items[0]).to eq(item_3)
        expect(merchant_1.ready_items[1]).to eq(item_4)
        expect(merchant_1.ready_items[2]).to eq(item_7)
        expect(merchant_1.ready_items[3]).to eq(item_4)
        expect(merchant_1.ready_items[4]).to eq(item_8)
        expect(merchant_1.ready_items[5]).to eq(item_4)
      end
    end

    describe '#filter_item_status' do
      it 'filters items by status' do
        expect(merchant_1.filter_item_status(1)).to include(item_1, item_3)
        expect(merchant_1.filter_item_status(0)).to include(item_2, item_4)
      end
    end

    describe '#top_items' do
      #does not work correctly when more than one type of item on invoice: rework
      xit 'returns the top 5 items by revenue for a merchant' do
        invoice_1.update(total: invoice_1.order_total)
        invoice_2.update(total: invoice_2.order_total)
        invoice_3.update(total: invoice_3.order_total)
        invoice_4.update(total: invoice_4.order_total)
        invoice_5.update(total: invoice_5.order_total)
        invoice_6.update(total: invoice_6.order_total)
        invoice_7.update(total: invoice_7.order_total)
        invoice_8.update(total: invoice_8.order_total)

        top_5_items = [item_1, item_2, item_3, item_8, item_4]
        expect(merchant_1.top_items).to eq(top_5_items)
      end
    end
  end
