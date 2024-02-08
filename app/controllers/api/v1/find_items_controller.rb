class Api::V1::FindItemsController < ApplicationController
  def index
    # require "pry"; binding.pry
    if params[:name]
      render json: ItemSerializer.new(Item
      .where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
      .order(:name))
    else
      render json: ItemSerializer.new(Item
      .where(:unit_price >= params[:min_price] && :unit_price <= params[:max_price])
      .order(:name))
    end
  end
         
end