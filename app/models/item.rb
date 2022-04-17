class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates :name, :description, :merchant, :status, presence: true
  validates :unit_price, numericality: true

  enum status: [:disabled, :enabled]

  def best_day
    invoices.joins(:invoice_items)
            .where('invoices.status = 2')
            .select('invoices.*, sum(invoice_items.calculated_price * invoice_items.quantity) as revenue')
            .group(:id)
            .order('revenue desc', 'created_at desc')
            .first&.created_at
  end

  def pretty_created_at
    created_at.strftime("%A, %B %-d, %Y")
  end

  def self.top_5
    # joins(invoices: [:invoice_items, :transactions])
    #   .where(invoices: {status: 1}, transactions: {result: 1})
    #   .select("items.*,  ")

  end
end
