class Api::UserTeamsController < ApplicationController
  before_action :set_userteam, only: :destroy

  def index
    @userteam = UserTeam.where(nil)
    # @userteam = UserTeam.where(user_id: 1)#filternya butuh current_id
    render json: { success: true, status: 200, data: @userteam.map {|userteam| userteam.new_attributes} }
  end

  def create
    @userteam = UserTeam.new(userteam_params)

    if @userteam.save
      render json: @userteam.new_attributes, status: :created
    else
      render json: @userteam.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @userteam.destroy
      render json: { message: 'success to delete UserTeams' }, status: 200
    else
      render json: { message: 'failed to delete UserTeams' }, status: 422
    end
  end

  private

  def set_userteam
    @userteam = UserTeam.find_by_id(params[:id])
    return unless @userteam.nil?

    render json: { error: 'Team not found' }, status: :not_found
  end

  def userteam_params
    params.permit(
      :profile_id,
      :team_id
    )
  end
end
