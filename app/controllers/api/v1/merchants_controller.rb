class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  # def create
  #   @merchant = Merchant.create!(merchant_params)
  # end

  # private

  # def merchant_params
  #   params.require(:merchant).permit(:name)
  # end
end

# module Api
#   module V1
#     class MerchantsController < ApplicationController
#       def index
#         render json: Merchant.all
#       end
#     end
#   end
# end

# class Api::V1::MerchantsController < ApplicationController
  # def index
  #   render json: Merchant.all
  # end
# end