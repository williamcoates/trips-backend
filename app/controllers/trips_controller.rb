# Currently two levels of access: :user or :admin. Admins can CRUD any
# trip, users can only CRUD their own trips
class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_access, only: [:destroy, :update]
  rescue_from ActiveRecord::RecordInvalid, with: :render_400

  def index
    render json: Trip.where(user: current_user)
  end

  def create
    trip = Trip.new(create_trip_params)
    trip.user = current_user
    trip.save!
    render json: trip
  end

  def destroy
    @trip.destroy
    render nothing: true
  end

  def update
    @trip.update!(trip_params)
    render json: @trip
  end

  protected

  def ensure_access
    @trip = Trip.find(params[:id])
    return if @trip.accessible_by?(current_user)
    render json: { error: 'You do not have access to manage that trip!' }, status: 401
  end

  def render_400(error)
    render json: { error: error.message }, status: 400
  end

  private

  def trip_params
    params.require(:trip).permit(:destination, :start_date, :end_date, :comment)
  end

  def create_trip_params
    params
      .require(:trip)
      .permit(:id, :destination, :start_date, :end_date, :comment)
  end
end
