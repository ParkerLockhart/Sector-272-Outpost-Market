class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  validates :customer, :merchant, :status, presence: true

  enum status: {
    "in progress" => 0,
    "completed" => 1,
    "cancelled" => 2
  }

  def pretty_created_at
    created_at.strftime("%A, %B %-d, %Y")
  end

  def customer_name
    customer.first_name + " " + customer.last_name
  end

  def items_info
    invoice_items.joins(:item)
      .select("invoice_items.*, items.name")
  end

  def order_total
    invoice_items.sum("calculated_price * quantity")
  end

  def total_with_discount
    invoice_items.sum do |ii|
      ii.discounted_total
    end
  end
end
