class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  validates :customer, :status, presence: true

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

  def total_revenue
    invoice_items.sum("unit_price * quantity").to_f / 100
  end

  def total_with_discount
    invoice_items.sum do |invoice_item|
      invoice_item.discounted_total
    end
  end


end
