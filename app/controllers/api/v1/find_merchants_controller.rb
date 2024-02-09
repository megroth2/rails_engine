class Api::V1::FindMerchantsController < ApplicationController
  def index
    if params[:name]
      merchant = Merchant.find_merchant_by_name(params[:name])
      if merchant.nil?
        render json: { data: {} }, status: :ok
      else
        render json: MerchantSerializer.new(merchant)
      end
    else
      render json: { error: "Name parameter required" }, status: :bad_request
    end
  end
end
