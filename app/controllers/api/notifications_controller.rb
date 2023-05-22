class Api::NotificationsController < ApplicationController
    before_action :authenticate_request
    before_action :set_notification, only: %i[update destroy show]

    def index
        @notification = Notification.all
        render json: { success: true, status: 200, data: @notification.map { |notification| notification.new_attr } }
    end

    def show
        render json: @notification.new_attr
    end

    def create
        @notification = Notification.new(notification_params)
    
        if @notification.save
          render json: { success: true, status: 201, message: 'create notification successfully', data: @notification.new_attr },
                 status: 201
        else
          render json: { success: false, status: 422, message: 'create notification unsuccessfully', data: @notification.errors },
                 status: 422
        end
    end

    def update
        if @notification.update(notification_params)
          render json: { success: true, status: 200, message: 'notification updated successfully', data: @notification.new_attr }, status: 200
        else
          render json: { success: false, status: 422, message: @notification.errors }, status: 422
        end
    end

    def destroy
        room = Notification.find(params[:id])
        room.destroy
        render json: "berhasil di hapus"
    end
    

    private

    def set_notification
        @notification = Notification.find(params[:id])
        return unless @notification.nil?
    
        render json: { status: 404, message: 'notification not found' }, status: 404
    end

    def notification_params
        params.permit(
         :title, :description, :user_id, :user_note_id, :user_team_id)
    end
end
