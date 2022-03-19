class CreateMerchantUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :merchant_users do |t|
      t.references :merchant, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
