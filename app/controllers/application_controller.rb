class ApplicationController < ActionController::API
  # refactor idea: continue adding error handling to the application controller
  rescue_from ActiveRecord::InvalidForeignKey, with: :not_found_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 404)
      ).serialize_json, status: :not_found
  end

  
end
