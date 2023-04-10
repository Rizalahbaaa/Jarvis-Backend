class Api::TeamsController < ApplicationController
    before_action :set_team, only: [:show, :update, :destroy]
  
    def index
      # binding.pry
      @team = Team.all
      render json: @team.map { |team| team.new_attributes }
    end
  
    def show
      render json: @team.new_attributes
      
    end
  
    def create
      @team = Team.new(team_params)
  
      if @team.save
        render json: @team.new_attributes, status: :created
      else
        render json: @team.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @team.update(team_params)
        render json: @team.new_attributes
      else
        render json: @team.errors, status: :unprocessable_entity
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
        if @team.nil?
          render json: { error: "Team not found" }, status: :not_found
        end
      end
  
    def team_params
    params.permit( 
     :title
    )
    end
end
