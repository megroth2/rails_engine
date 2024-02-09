class Api::V1::FindItemsController < ApplicationController  
  # refactor idea: move into helper methods
  # refactor idea: move error handling logic to the application controller
  def index
    if params[:name] && params[:name].blank?
      render json: { error: "Name fragment is empty" }, status: :bad_request
    elsif params[:name] && (params[:min_price] || params[:max_price])
      render json: { error: "Cannot search by both name and price" }, status: :bad_request
    elsif params[:name]
      items = Item.find_items_by_name(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price] && params[:min_price].to_f < 0
      render json: { errors: "Min price less than 0" }, status: :bad_request
    elsif params[:max_price] && params[:max_price].to_f < 0
      render json: { errors: "Max price less than 0" }, status: :bad_request  
    elsif params[:min_price] && params[:max_price]
      items = Item.find_items_by_min_and_max_price(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(items)
    elsif params[:min_price] 
        items = Item.find_items_by_min_price(params[:min_price])
        render json: ItemSerializer.new(items)
    elsif params[:max_price]
      items = Item.find_items_by_max_price(params[:max_price])
      render json: ItemSerializer.new(items)
    else
      render json: { error: "No param given" }, status: :bad_request
    end
  end
end
