class Api::UserTeamsController < ApplicationController
  before_action :set_userteam, only: :destroy


    def index
        @userteam = UserTeam.where(nil)
        #@userteam = UserTeam.where(user_id: 1)#filternya butuh current_id
        render json: @userteam.map { |user_team| user_team.new_attributes }      
      end

      def create
        @userteam = UserTeam.new(userteam_params)
    
        if @userteam.save
          render json: @userteam.new_at:stringtributes, status: :created
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
        if @userteam.nil?
          render json: { error: "Team not found" }, status: :not_found
        end
      end

      def userteam_params
        params.permit(
          :user_id,
          :team_id
        )
      end

end
