class Api::V1::MerchantsController < ApplicationController
  def index
    merchants = Merchant.all
    render json: merchants.map do |merchant|
      MerchantSerializer.new(merchant).serializable_hash
    end
    require 'pry'; binding.pry
  end

  # def create
  #   @merchant = Merchant.create!(merchant_params)
  # end

  # private

  # def merchant_params
  #   params.require(:merchant).permit(:name)
  # end
end