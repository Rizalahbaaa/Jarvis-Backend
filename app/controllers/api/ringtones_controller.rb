class Api::RingtonesController < ApplicationController
  before_action :set_ringtone, only: [:show, :update, :destroy]

  def index
    @ringtones = Ringtone.all
    render json: { success: true, message: 'data found', status: 200, data: @ringtones.map { |ringtone| ringtone.new_attr } }
  end
  
  def create
    @ringtone = Ringtone.new(ringtone_params)
    if @ringtone.save
        render json: { success: true, message: 'upload ringtone successfully', status: 201, data: @ringtone.new_attr }, status: 201
      else
        render json: { success: false, message: 'upload ringtone unsuccessfully', status: 422, data: @ringtone.errors }, status: 422
    end
  end

  def show
    render json: @ringtone.new_attr
  end
  
  def update
    if @ringtone.update(ringtone_params)
        render json: { success: true, message: 'update ringtone successfully', status: 200, data: @ringtone.new_attr }, status: 200
      else
        render json: { success: false, status: 422, message: @ringtone.errors }, status: 422
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
    return render json: { message: "ringtone not found" }, status: :not_found if @ringtone.nil?
  end
  
  def ringtone_params
    params.require(:ringtone).permit(:name, :path)
  end
end
