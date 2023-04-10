class Api::TeamsController < ApplicationController
  before_action :set_team, only: %i[show update destroy]

  def index
    @team = Team.all
    render json: { success: true, status: 200, data: @team.map {|team| team.new_attributes} }
  end

  def show
    render json: @team.new_attributes
  end

  def create
    @team = Team.new(team_params)

    if @team.save
      render json: { success: true, status: 201, data: @team.new_attr }, status: 201
    else
      render json: { success: false, status: 422, message: @team.errors }, status: 422
    end
  end

  def update
    if @team.update(team_params)
      render json: { success: true, status: 200, data: @team.new_attr }, status: 200
    else
      render json: { success: false, status: 422, message: @team.errors }, status: 422
    end
  end

  def destroy
    if @team.destroy
      render json: { message: 'success to delete teams' }, status: 200
    else
      render json: { message: 'failed to delete teams' }, status: 422
    end
  end

  private

  def set_team
    @team = Team.find_by_id(params[:id])
    return unless @team.nil?

    render json: { status: 404, message: 'team not found' }, status: 404
  end

  def team_params
    params.permit(
      :title
    )
  end
end
