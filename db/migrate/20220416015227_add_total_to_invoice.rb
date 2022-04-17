class AddTotalToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :total, :integer
  end
end
