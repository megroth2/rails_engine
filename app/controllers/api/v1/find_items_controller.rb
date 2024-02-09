class Api::V1::FindItemsController < ApplicationController
  # def index
  #   if params[:name]
  #     render json: ItemSerializer.new(Item
  #       .where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
  #       .order(:name))
  #   else
  #     render json: ItemSerializer.new(Item
  #       .where(:unit_price >= params[:min_price] && :unit_price <= params[:max_price])
  #       .order(:name))
  #   end
  # end    

  # refactor idea: we can pull a lot of the logic below out into helper methods
  def index
    if params[:name]
      render json: ItemSerializer.new(Item
        .where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
        .order(:name))
    elsif params[:min_price] && params[:max_price] && params[:name]
      render json: ItemSerializer.new(Item
      .where(:unit_price >= params[:min_price] && :unit_price <= params[:max_price]))
    elsif params[:min_price]
      render json: ItemSerializer.new(Item
      .where(:unit_price >= params[:min_price]))
    elsif params[:max_price]
      render json: ItemSerializer.new(Item
      .where(:unit_price <= params[:max_price]))
    else
      # handle error
    end
  end    
end