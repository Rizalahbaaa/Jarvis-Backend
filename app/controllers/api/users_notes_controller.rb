class Api::UsersNotesController < ApplicationController
  def index
    @user_notes = UserNote.all
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end

  def create
    @user_note = UserNote.new(user_note_params)
    if @user_note.save
      render json: { success: true, status: 201, data: @user_note.new_attr }, status: 201
    else
      render json: { success: false, status: 422, data: @user_note.errors }, status: 422
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

  def user_note_params
    params.require(:users_note).permit(:note_id, :user_id, :reminder, :role, :status)
  end
end
