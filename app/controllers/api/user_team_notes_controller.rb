class Api::UserTeamNotesController < ApplicationController

    def index
        @user_team_notes = User_Team_Note.all
        render json: @user_team_notes
    end

    def show
        render json: User_Team_Note.find(params[:id])
    end

    def create
        @user_team_notes = User_Team_Note.new(user_team_notes_params)
        if @user_team_notes.save
            render json: @user_team_notes, status: :created, location: @user_team_notes
        else
            render json: @user_team_notes.errors, status: :unprocessable_entity
        end
    end

    def update
        @user_team_notes = User_Team_Note.find(params[:id])
        if @user_team_notes.update(user_team_notes_params)
            render json: @user_team_notes
        else
            render json: @user_team_notes.errors, status: :unprocessable_entity
        end
    end

    def destroy
        room = User_Team_Note.find(params[:id])
        room.destroy
        render json: "berhasil di hapus"
    end
    

    private
    def set_user_team_notes
        @user_team_notes = User_Team_Note.find(params[:id])
    end

    def user_team_notes_params
        params.require(:user_team_notes).permit(
         :role, :user_id, :team_notes_id)
    end

end