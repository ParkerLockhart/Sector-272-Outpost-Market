class MerchantUser < ApplicationRecord
  belongs_to :merchant
  belongs_to :user
end 
