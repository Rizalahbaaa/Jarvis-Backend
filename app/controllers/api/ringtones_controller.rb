class Api::RingtonesController < ApplicationController

  def index
    @ringtones = Ringtone.all
    render json: { success: true, status: 200, data: @ringtones.map { |ringtone| ringtone.new_attr } }
  end

  def show
    render json: Ringtone.find(params[:id])
  end

  def create
    @ringtones = Ringtone.new(ringtones_params)
    if @ringtones.save
      render json: { success: true, status: 201, data: @ringtones.new_attr }, status: 201
    else
      render json: { success: false, status: 422, message: @ringtones.errors }, status: 422
    end
  end

  def update
    @ringtones = Ringtone.find(params[:id])
    if @ringtones.update(ringtones_params)
      render json: @ringtones
    else
      render json: @ringtones.errors, status: :unprocessable_entity
    end
  end

  def destroy
    room = Ringtone.find(params[:id])
    room.destroy
    render json: 'berhasil di hapus'
  end

  private

  def set_ringtones
    @ringtones = Ringtone.find(params[:id])
  end

  def ringtones_params
    params.require(:ringtone).permit(
      :name, :file
    )
  end
end
