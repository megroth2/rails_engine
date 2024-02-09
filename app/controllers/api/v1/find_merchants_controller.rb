class Api::V1::FindMerchantsController < ApplicationController
  def index
    if params[:name]
      merchant = Merchant.find_merchant_by_name(params[:name])
      render json: MerchantSerializer.new(merchant)
    else
      # error
    end
  end
end
