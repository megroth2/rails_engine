class ApplicationController < ActionController::API
  rescue_from ActiveRecord::InvalidForeignKey, with: :not_found_response
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(
      ErrorMessage.new(exception.message, 404)
      ).serialize_json, status: :not_found
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end
end
