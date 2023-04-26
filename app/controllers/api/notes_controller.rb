class Api::NotesController < ApplicationController
  before_action :set_note, only: %i[update destroy]
  def index
    @notes = Note.all
    render json: { success: true, status: 200, data: @notes.map { |note| note.new_attr } }
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      render json: { success: true, message: 'note created successfully', status: 201, data: @note.new_attr },
             status: 201
    else
      render json: { success: false, message: 'note created unsuccessfully', status: 422, data: @note.errors },
             status: 422
    end
  end

  def update
    if @note.update(note_params)
      render json: { success: true, message: 'note updated successfully', status: 200, data: @note.new_attr },
             status: 200
    else
      render json: { success: false, message: 'note updated unsuccessfully', status: 422, data: @note.errors },
             status: 422
    end
  end

  def destroy
    if @note.destroy
      render json: { success: true, status: 200, message: 'note deleted successfully' }, status: 200
    else
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
end
