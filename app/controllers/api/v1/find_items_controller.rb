class Api::V1::FindItemsController < ApplicationController
  def index
    if params.key?(:name) && params[:name].blank?
      render json: { error: "Name fragment is empty" }, status: :bad_request
    elsif params[:name] && (params[:min_price] || params[:max_price])
      render json: { error: "Cannot search by both name and price" }, status: :bad_request
    elsif params[:name]
      render json: ItemSerializer.new(Item
        .where("lower(name) LIKE ?", "%#{params[:name].downcase}%")
        .order(:name))
    elsif params[:min_price] && params[:min_price].to_f < 0
      render json: { errors: "Min price less than 0" }, status: :bad_request
    elsif params[:max_price] && params[:max_price].to_f < 0
      render json: { errors: "Max price less than 0" }, status: :bad_request  
    elsif params[:min_price] 
      render json: ItemSerializer.new(Item
        .where('unit_price >= ?', params[:min_price])
        .order(:name))
    elsif params[:max_price]
      render json: ItemSerializer.new(Item
      .where('unit_price <= ?', params[:max_price])
        .order(:name))
    else
      render json: { error: "No param given" }, status: :bad_request
    end
  end
         
end