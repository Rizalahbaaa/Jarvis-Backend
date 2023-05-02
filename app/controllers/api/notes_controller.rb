class Api::NotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_note, only: %i[update destroy]
  def index
    @notes = Note.all
    render json: { success: true, status: 200, data: @notes.map { |note| note.new_attr } }
  end

  def create
    @note = Note.create(note_params)
    @user = current_user
    @user_note = @user.user_notes.build(usernote_params)
    @user_note.note = @note
    if @note.save && @user_note.save
      render json: { success: true, message: 'note created successfully', status: 201, data: @note.new_attr },
             status: 201
    else
      render json: { success: false, message: 'note created unsuccessfully', status: 422, data: @note.errors, test:@user_note.errors},
             status: 422
    end
  end

  def update
    @noteid = Note.notefunc(@note)
    if @noteid.owners?(current_user) != true 
      render json: { success: false, status: 422, message: 'only owner can update note' }
   elsif @noteid.owners?(current_user) == true && @note.update(note_params)
      render json: { success: true, message: 'note updated successfully', status: 200, data: @note.new_attr },
             status: 200
   elsif
      render json: { success: false, message: 'note updated unsuccessfully', status: 422, data: @note.errors },
             status: 422
    end
  end

  def destroy
    @noteid = Note.notefunc(@note)
    if @noteid.owners?(@current_user) != true 
      render json: { success: false, status: 422, message: 'only owner can delete note' }
    elsif @noteid.owners?(@current_user) == true && @note.destroy
      render json: { success: true, status: 200, message: 'note deleted successfully' }, status: 200
    elsif
      render json: { success: true, status: 422, message: 'note deleted unsuccessfully' }, status: 422
    end
  end

  private

  def set_note
    @note = Note.find_by_id(params[:id])
    return unless @note.nil?

    render json: { status: 404, message: 'note not found' }, status: 404
  end

  def note_params
    params.require(:note).permit(:subject, :description, :event_date, :ringtone_id, :column_id, :note_type, :status)
  end

  def usernote_params
    params.require(:user_note).permit(:reminder)
  end
end
