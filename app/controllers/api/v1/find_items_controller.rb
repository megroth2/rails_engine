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
    if params[:name] && params[:min_price] && params[:max_price]
      # error - too many search criteria/invalid search
    elsif params[:name]
      items = Item.find_items_by_name(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price] && params[:max_price]
      items = Item.find_items_by_min_and_max_price(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(items)
    elsif params[:min_price]
      items = Item.find_items_by_min_price(params[:min_price])
      render json: ItemSerializer.new(items)
    elsif params[:max_price]
      render json: ItemSerializer.new(Item
      .where(item.unit_price <= params[:max_price].to_f)
      .order(:name))
    else
      # handle error
    end
  end
end