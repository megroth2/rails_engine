class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: ItemSerializer.new(items)
  end

  def show
  end

  def update
    item = Item.find(params[:id]) # whats the best way to implement error handling for when the item is not found? Would it be to add a helper method with if else statements like the one below?
    if item.update!(item_params) 
      render json: ItemSerializer.new(item)
      # render json: Item.update(params[:id], item_params)
    else
      # Add Error Handling
    end
  end

  private

    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      # binding.pry
    end
end