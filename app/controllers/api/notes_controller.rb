class Api::NotesController < ApplicationController
  before_action :set_note, only: %i[update destroy]
  def index
    @notes = Note.all
    render json: @notes.map { |note| note.new_attr }
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      render json: @note.new_attr, status: 201
    else
      render json: @note.errors, status: 422
    end
  end

  def update
    if @note.update(note_params)
      render json: @note.new_attr
    else
      render json: @note.errors, status: 422
    end
  end

  def destroy
    if @note.destroy
      render json: { message: 'success to delete note' }, status: 200
    else
      render json: { message: 'fail to delete note' }, status: 422
    end
  end

  private

  def set_note
    @note = Note.find_by_id(params[:id])
    return unless @note.nil?

    render json: { error: 'note not found' }, status: 404
  end

  def note_params
    params.require(:note).permit(:subject, :description, :event_date, :reminder_date, :ringtone_id)
  end
end
ser
