class Api::RemindersController < ApplicationController
  before_action :set_reminder, only: %i[update destroy]
  def index
    @reminders = Reminder.all
    render json: { success: true, status: 200, data: @reminders.map {|reminder| reminder.new_attr} }
  end

  def create
    @reminder = Reminder.new(reminder_params)
    if @reminder.save
      render json: { success: true, status: 201, data: @reminder.new_attr }, status: 201
    else
      render json: { success: false, status: 422, message: @reminder.errors }, status: 422
    end
  end

  def update
    if @reminder.update(reminder_params)
      render json: { success: true, status: 200, data: @reminder.new_attr }, status: 200
    else
      render json: { success: false, status: 422, message: @reminder.errors }, status: 422
    end
  end

  def destroy
    if @reminder.destroy
      render json: { success: true, status: 200, message: 'reminde@reminder deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'reminde@reminder deleted unsuccessfully' }, status: 422
    end
  end

  private

  def set_reminder
    @reminder = Reminder.find(params[:id])
    return unless @reminder.nil?

    render json: { status: 404, message: 'reminder not found' }, status: 404
  end

  def reminder_params
    params.permit(:note_id, :reminder_date)
  end
end
