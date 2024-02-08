class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    if merchant = Merchant.find(params[:id])
      render json: ItemSerializer.new(merchant.items)
    else
      render json: { error: "Merchant not found" }, status: :not_found
    end
  end

end