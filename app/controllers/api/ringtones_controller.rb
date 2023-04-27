class Api::RingtonesController < ApplicationController
  before_action :set_ringtone, only: %i[show update destroy]

  def index
    @ringtones = Ringtone.all
    render json: { success: true, status: 200, data: @ringtones.map { |ringtone| ringtone.new_attr } }
  end
  
  def create
    @ringtone = Ringtone.new(ringtone_params)
    if @ringtone.save
        render json: { success: true, message: 'ringtone uploaded successfully', status: 201, data: @ringtone.new_attr }, status: 201
      else
        render json: { success: false, message: 'ringtone uploaded unsuccessfully', status: 422, data: @ringtone.errors }, status: 422
    end
  end

  def show
    render json: @ringtone.new_attr
  end
  
  def update
    if @ringtone.update(ringtone_params)
        render json: { success: true, message: 'ringtone updated successfully', status: 200, data: @ringtone.new_attr }, status: 200
      else
        render json: { success: false, message: 'ringtone updated unsuccessfully', status: 422, data: @ringtone.errors }, status: 422
    end
  end
      
  def destroy
    if @ringtone.destroy
        render json: { success: true, status: 200, message: 'ringtone deleted successfully' }, status: 200
      else
        render json: { success: true, status: 422, message: 'ringtone deleted unsuccessfully' }, status: 422
    end
  end
  
  private
  def set_ringtone
    @ringtone = Ringtone.find(params[:id])
    return unless @ringtone.nil?
    render json: { status: 404, message: "ringtone not found" }, status: 404
  end
  
  def ringtone_params
    params.require(:ringtone).permit(:name, :path)
  end
end
