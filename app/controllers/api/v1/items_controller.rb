class Api::V1::ItemsController < ApplicationController
  # refactor idea: add set_merchant and set_item private methods, add a before_action for each to reduce redundancy of `merchant = Merchant.find(params[:merchant_id])` and `item = Item.find(params[:id])` - this can likely be applied to most controllers, so maybe even move it to the application controller
  # refactor idea: remove nested if statements from index action
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      if merchant
        render json: ItemSerializer.new(merchant.items)
      else
        render json: { error: "Merchant not found" }, status: :not_found
      end
    else
      render json: ItemSerializer.new(Item.all)
    end
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

  def merchant
    item = Item.find(params[:id])
    render json: MerchantSerializer.new(item.merchant)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end