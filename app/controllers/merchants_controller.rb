class MerchantsController < ApplicationController
  before_action :require_manager_user, only: [:show]
  def new
    @merchant = Merchant.new
  end

  def create
    user = current_user
    merchant = Merchant.new(merchant_params)
    merchant_user = MerchantUser.new(merchant: merchant, user: current_user)
    user.update(role: "manager")

    if merchant.save && merchant_user.save && user.save
      redirect_to '/merchants/dashboard'
    else
      redirect_to '/merchants/new'
      flash[:error] = "Error: Something went wrong."
    end 
  end

  def show
    if current_user.role == "manager"
      @user = current_user
      @merchant = @user.merchants.first
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end
