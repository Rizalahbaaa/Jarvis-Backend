class Api::UsersNotesController < ApplicationController
  before_action :set_usernote, only: %i[ show update destroy ]
  before_action :authenticate_request, except: %i[accept_invitation decline_invitation]

  def index
    @user_notes = UserNote.all
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end

  def reqlist
    @user_notes = UserNote.joins(:note).where(notes: { note_type: 'collaboration' }).where(user_id: current_user, noteinvitation_status: 'Pending')
    @user_teams = UserTeam.where(user_id: current_user, teaminvitation_status: 'Pending', team_role: 'member')
    combined_data = @user_notes.map {|user_note| user_note.inv_request} + @user_teams.map {|user_team|user_team.inv_reqteam}
    render json: { success: true, status: 200, data: combined_data}
  end

  def show
    render json: {success: true, status: 200, data: @user_note.new_attr}, status: 200
  end



  def accept_invitation
    @user_note = UserNote.find_by(noteinvitation_token: params[:noteinvitation_token])

    if @user_note && @user_note.invitation_valid?
      @user_note.accept_invitation!
      render json: { status: 200, message: "Undangan Diterima"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def decline_invitation
    @user_note = UserNote.find_by(noteinvitation_token: params[:noteinvitation_token])

    if @user_note && @user_note.invitation_valid?
      @user_note.decline_invitation!
      render json: { status: 200, message: "Undangan Ditolak"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def destroy
    @user_note = UserNote.find_by_id(params[:id])
    if @user_note.destroy
      render json: { success: true, status: 200, message: 'user_note deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'user_note deleted unsuccessfully' }, status: 422
    end
  end

  private

  # def user_note_params
  #   params.require(:users_note).permit(:note_id, :user_id, :reminder, :role, :status)
  # end

  def set_usernote
    @user_note = UserNote.find_by_id(params[:id])
    return unless @user_note.nil?

    render json: { status: 404, message: 'note not found' }, status: 404
  end

  # def noteinvite_params
  #   params.require(:users_note).permit(:note_id, :user_id, :noteinvitation_token)
  # end
  
end
