class Api::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  skip_before_action :verify_authenticity_token

  include AdHelper

  def index
    render json: {}
  end

  def total_kg
    render json: {"total_kg": great_total_quantity}
  end

  def categories
    render json: {"categories": Ad::FOOD_CATEGORIES}
  end

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization']) if request.headers['Authorization'].present?
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  protected

  def pagination(paginated_array, per_page)
    { pagination: { per_page: per_page.to_i,
      total_pages: paginated_array.total_pages,
      total_objects: paginated_array.total_count } }
    end
end
