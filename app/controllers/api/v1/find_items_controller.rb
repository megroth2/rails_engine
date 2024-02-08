class Api::V1::FindItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item
          .where()
end