class Api::AttachesController < ApplicationController
  before_action :authenticate_request
  before_action :set_attach, only: %i[show update destroy]

  def index
    @attaches = Attach.all
    render json: { success: true, status: 200, data: @attaches.map { |attach| attach.new_attr } }
  end

  def create
    user_note = UserNote.find_by(user: current_user, note: params[:note_id])
    files = params[:path]
    attachment = []
    is_valid = true
    errors = nil

    if files.present?
      files.each do |p|
        attach = {
          path: p,
          user_note_id: user_note.id
        }
        attachment << attach
      end

      attach = Attach.create(attachment)
      attach.map do |a|
        is_valid = a.valid?
        errors = a.errors unless is_valid
        break unless is_valid
      end

      if attach.present? && user_note.update_status && user_note.update_time && is_valid
        render json: { success: true, message: 'file uploaded successfully', status: 201, data: attach.map{|a| a.new_attr}},
               status: 201
      else
        render json: { success: false, message: 'file uploaded unsuccessfully', status: 422, data: errors },
                status: 422
      end
      return
    end
    render json: {status: 400, success: false, message: 'no files to upload'}, status: 400
  end

  def show
    render json: @attach.new_attr
  end

  def destroy
    if @attach.destroy
      render json: { success: true, status: 200, message: 'file deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'file deleted unsuccessfully' }, status: 422
    end
  end

  private

  def set_attach
    @attach = Attach.find(params[:id])
    return unless @attach.nil?

    render json: { status: 404, message: 'file not found' }, status: 404
  end
end
