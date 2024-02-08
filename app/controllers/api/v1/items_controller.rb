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
    item.destroy_with_invoice_items_and_invoices
  end
end