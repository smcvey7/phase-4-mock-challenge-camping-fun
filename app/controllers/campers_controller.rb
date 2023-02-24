class CampersController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def index
    campers = Camper.all
    render json: campers
  end

  def show
    camper = find_camper
    render json: camper, serializer: CamperActivitiesSerializer
  end

  def create
    camper = Camper.create!(camper_params)
    render json: camper, status: :created
  end

  private

  def camper_params
    params.permit(:name, :age)
  end

  def find_camper
    Camper.find_by!(id: params[:id])
  end

  def render_record_not_found_response
    render json: {error: "Camper not found"}, status: :not_found
  end

  def render_record_invalid(e)
    
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

end
