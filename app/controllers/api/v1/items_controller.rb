class Api::V1::ItemsController < ApplicationController
  def index
    items = Item.all
    render json: items.map do |item|
      ItemSerializer.new(item)
    end
  end
end