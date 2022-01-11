class MerchantItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    if params[:status] == "enabled"
      item.update(status: 1)
      redirect_to "/merchants/#{params[:merchant_id]}/items"
    elsif params[:status] == "disabled"
      item.update(status: 0)
      redirect_to "/merchants/#{params[:merchant_id]}/items"
    else
      item.update(item_params)
      redirect_to "/merchants/#{params[:merchant_id]}/items/#{item.id}"
      flash[:alert] = "Successfully Updated Item"
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.new(item_params)
    if item.save
      redirect_to "/merchants/#{merchant.id}/items"
    else
      message = item.errors.full_messages.to_sentence
      flash[:notice] = "Item not created: #{message}"
      
      redirect_to "/merchants/#{merchant.id}/items"
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :status)
  end
end
