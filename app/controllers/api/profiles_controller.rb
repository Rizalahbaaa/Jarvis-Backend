class Api::ProfilesController < ApplicationController
  before_action :set_profile, only: %i[update destroy]
  def index
    @profiles = Profile.all
    render json: @profiles.map { |profile| profile.new_attr }
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      render json: @profile.new_attr, status: 201
    else
      render json: @profile.errors, status: 422
    end
  end

  def update
    if @profile.update(profile_params)
      render json: @profile.new_attr
    else
      render json: @profile.errors, status: 422
    end
  end

  def destroy
    if @profile.destroy
      render json: { message: 'success to delete profile' }, status: 200
    else
      render json: { message: 'fail to delete profile' }, status: 422
    end
  end

  private

  def set_profile
    @profile = Profile.find_by_id(params[:id])
    return unless @profile.nil?

    render json: { error: 'profile not found' }, status: 404
  end

  def profile_params
    params.permit(:username, :job_id, :phone, :photo, :user_id)
  end
end
