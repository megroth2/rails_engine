class Api::V1::FindMerchantsController < ApplicationController
  def index
    if params[:name].present?
      merchant = Merchant
          .where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
          .order(:name)
          .first
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
