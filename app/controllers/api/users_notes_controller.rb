class Api::UsersNotesController < ApplicationController
  def index
    @user_notes = UserNote.all
    render json: @user_notes.map { |user_note| user_note.new_attr }
  end

  def create
    @user_note = UserNote.new(user_note_params)
    if @user_note.save
      render json: @user_note.new_attr, status: 201
    else
      render json: @user_note.errors, status: 422
    end
  end

  def destroy
    @note = Note.find_by_id(params[:id])
    if @note.destroy
      render json: { message: 'success to delete user_note' }, status: 200
    else
      render json: { message: 'fail to delete user_note' }, status: 422
    end
  end

  private

  def user_note_params
    params.require(:users_note).permit(:note_id, :user_id, :role)
  end
end
