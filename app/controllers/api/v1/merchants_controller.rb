class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: MerchantSerializer.new(merchants)
  end

  # def create
  #   @merchant = Merchant.create!(merchant_params)
  # end

  # private

  # def merchant_params
  #   params.require(:merchant).permit(:name)
  # end
end