class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.new(merchants)
  end

  # def show
  #   if params[:item_id]
  #     item = Item.find(params[:item_id])
  #     render json: MerchantSerializer.new(item.merchant)
  #   else
  #     render json: MerchantSerializer.new(Merchant.find(params[:id])
  #   end
  # end

  def show
    item = Item.find(params[:id])
    render json: MerchantSerializer.new(item.merchant)
  end
  

  # def show
  #   if params[:id]
  #     item = Item.find(params[:id])
  #     if item
  #       render json: MerchantSerializer.new(item.merchant)
  #     else
  #       render json: { error: "Item not found" }, status: :not_found
  #     end
  #   else
  #     render json: MerchantSerializer.new(Merchant.find(params[:id]))
  #   end
  # end
end