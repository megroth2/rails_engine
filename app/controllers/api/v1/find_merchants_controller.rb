class Api::V1::FindMerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant
          .where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
          .order(:name)
          .limit(1))
  end
end
