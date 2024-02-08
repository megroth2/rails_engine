class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: ItemSerializer.new(items)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def destroy
    item = Item.find(params[:id])
    item.invoice_items.destroy # can't destroy an item without first destroying invoice items
    item.destroy
    render json: ItemSerializer.new(item)
  end
end