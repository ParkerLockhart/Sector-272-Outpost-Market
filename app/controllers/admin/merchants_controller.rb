class Admin::MerchantsController < ApplicationController
  def index
    @enabled_merchants = Merchant.where(status: 1)
    @disabled_merchants = Merchant.where(status: 0)
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def create
    Merchant.create!(merchant_params)
    redirect_to "/admin/merchants"
  end

  def update
    merchant = Merchant.find(params[:id])
    if params[:merchant][:status] == "enabled"
      merchant.update(status: "enabled")
      redirect_to admin_merchants_path
    elsif params[:merchant][:status] == "disabled"
      merchant.update(status: "disabled")
      redirect_to admin_merchants_path
    elsif merchant.update(merchant_params)
      redirect_to admin_merchant_path(merchant)
      flash[:alert] = "Successfully Updated Item"
    else
      redirect_to "/admin/merchants/#{merchant.id}/edit"
      flash[:alert] = "Error: #{error_message(merchant.errors)}"
    end
  end

private
  def merchant_params
    params.require(:merchant).permit(:name, :status)
  end
end
