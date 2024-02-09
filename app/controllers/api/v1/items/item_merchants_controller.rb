class Api::V1::Items::ItemMerchantsController < ApplicationController
  def index
    if params[:name].present?
      render_merchant_by_name(params[:name])
    else
      render json: { error: "Name parameter required" }, status: :bad_request
    end
  end

  private

  def render_merchant_by_name(name)
    render json: { error: "Name fragment is empty" }, status: :bad_request and return unless name.present?
  
    merchant = Merchant.find_merchant_by_name(name)
    render json: { data: {} }, status: :ok and return unless merchant
  
    render json: MerchantSerializer.new(merchant)
  end
end