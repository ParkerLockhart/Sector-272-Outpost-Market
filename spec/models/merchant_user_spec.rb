require 'rails_helper'

RSpec.describe MerchantUser, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should belong_to(:user) }
  end
end
