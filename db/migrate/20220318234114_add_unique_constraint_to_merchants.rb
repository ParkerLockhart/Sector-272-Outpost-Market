class AddUniqueConstraintToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_index :merchants, :name, unique: true
  end
end
