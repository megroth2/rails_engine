class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.new(merchants)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def items
    if merchant = Merchant.find(params[:id])
      merchant_items = merchant.items
      render json: merchant_items
    else
      head :not_found
    end
  end

  # def create
  #   @merchant = Merchant.create!(merchant_params)
  # end

  # private

  # def merchant_params
  #   params.require(:merchant).permit(:name)
  # end
end