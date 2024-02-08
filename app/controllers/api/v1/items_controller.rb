class Api::V1::ItemsController < ApplicationController
  # def index
  #   if params[:id].present? && merchant = Merchant.find(params[:id]) # merchant is provided and found
  #     render json: ItemSerializer.new(merchant.items)
  #   elsif params[:id].present? #merchant is provided but not found
  #     render json: { error: "Merchant not found" }, status: :not_found
  #   else # merchant is not provided
  #     render json: ItemSerializer.new(Item.all)
  #   end
  # end

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params) 
      render json: ItemSerializer.new(item)
    else
      render json: { error: "Item not found" }, status: :not_found
    end
  end
  
  def create
    new_item = Item.new(item_params)
    if new_item.save
      render json: ItemSerializer.new(new_item), status: :created
    else
      render json: { error: "Missing attribute(s) for item creation" }, status: :unprocessable_entity
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy_with_invoice_items_and_invoices
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end