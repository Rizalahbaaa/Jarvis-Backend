class Api::TeamNotesController < ApplicationController

    def index
        @team_notes = TeamNote.all
        render json: @team_notes
    end

    def show
        render json: TeamNote.find(params[:id])
    end

    def create
        @team_notes = TeamNote.new(team_notes_params)
        if @team_notes.save
            render json: @team_notes, status: :created, location: @team_notes
        else
            render json: @team_notes.errors, status: :unprocessable_entity
        end
    end

    def update
        @team_notes = TeamNote.find(params[:id])
        if @team_notes.update(team_notes_params)
            render json: @team_notes
        else
            render json: @team_notes.errors, status: :unprocessable_entity
        end
    end

    def destroy
        room = TeamNote.find(params[:id])
        room.destroy
        render json: "berhasil di hapus"
    end
    

    private
    def set_team_notes
        @team_notes = Team_Note.find(params[:id])
    end

    def team_notes_params
        params.require(:team_notes).permit(
         :subject, :description, :event_date, :reminders, :list_id, :ringtones_id)
    end
end