class Api::ProfilesController < ApplicationController
  before_action :set_profile, only: %i[update destroy]
  def index
    @profiles = Profile.all
    render json: { success: true, status: 200, data: @profiles.map { |profile| profile.new_attr} }
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      render json: { success: true, status: 201, data: @profile.new_attr }, status: 201
    else
      render json: { success: false, status: 422, message: @profile.errors }, status: 422
    end
  end

  def update
    if @profile.update(profile_params)
      render json: { success: true, status: 200, data: @profile.new_attr }, status: 200
    else
      render json: { success: false, status: 422, message: @profile.errors }, status: 422
    end
  end

  def destroy
    if @profile.destroy
      render json: { success: true, status: 200, message: 'profile deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'profile deleted unsuccessfully' }, status: 422
    end
  end

  private

  def set_profile
    @profile = Profile.find_by_id(params[:id])
    return unless @profile.nil?

    render json: { status: 404, message: 'profile not found' }, status: 404
  end

  def profile_params
    params.require(:profile).permit(:username, :job_id, :phone, :photo, :user_id)
  end
end
