class RenameInvoiceItemsUnitPrice < ActiveRecord::Migration[5.2]
  def change
    rename_column :invoice_items, :unit_price, :calculated_price
  end
end
