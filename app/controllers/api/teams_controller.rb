class Api::TeamsController < ApplicationController
  before_action :set_team, only: %i[show update destroy]

  def index
    @teams = Team.all
    render json: { success: true, status: 200, data: @teams.map {|team| team.new_attributes} }
  end

  def show
    render json: @team.new_attributes
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      render json: { success: true, message: 'team created successfully', status: 201, data: @team.new_attributes }, status: 201
    else
      render json: { success: false, message: 'team created unsuccessfully', status: 422, data: @team.errors }, status: 422
    end
  end

  def update
    if @team.update(team_params)
      render json: { success: true, message: 'team updated successfully', status: 200, data: @team.new_attributes }, status: 200
    else
      render json: { success: false, message: 'team updated unsuccessfully', status: 422, data: @team.errors }, status: 422
    end
  end

  def destroy
    if @team.destroy
      render json: { success: true, status: 200, message: 'team deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'team deleted unsuccessfully' }, status: 422
    end
  end

  private
  def set_team
    @team = Team.find_by_id(params[:id])
    return unless @team.nil?
    render json: { status: 404, message: 'team not found' }, status: 404
  end

  def team_params
    params.require(:team).permit(:title)
  end
end
