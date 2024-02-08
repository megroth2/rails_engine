class Api::V1::Merchants::ItemsController < ApplicationController

  def index
    if merchant = Merchant.find(params[:merchant_id])
      render json: ItemSerializer.new(merchant.items)
    else
      head :not_found
    end
  end

end