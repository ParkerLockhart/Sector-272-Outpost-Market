require 'rails_helper'

RSpec.describe Item, type: :model do
  before(:each) do
    @invoice_item = FactoryBot.create(:invoice_item)
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:merchant) }
    it { should validate_numericality_of(:unit_price) }
    it { should define_enum_for(:status).with_values(disabled: 0,enabled: 1) }
  end

  describe '#date_created' do
    it 'returns the date created of an items invoice and formats it' do
      expect(@invoice_item.item.date_created).to eq(@invoice_item.invoice.created_at.strftime("%A, %B %-d, %Y"))
    end
  end
end
