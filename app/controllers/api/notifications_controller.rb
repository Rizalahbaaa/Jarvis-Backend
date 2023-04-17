class Api::NotificationsController < ApplicationController
    def index
        @notification = Notification.all
        render json: @notification.map { |notification| notification.new_attr }
    end

    def show
        render json: Notification.find(params[:id])
    end

    def create
        @notification = Notification.new(notification_params)
        if @notification.save
            render json: @notification.new_attr, status: :created
        else
            render json: @notification.errors, status: :unprocessable_entity
        end
    end

    def update
        @notification = Notification.find(params[:id])
        if @notification.update(notification_params)
            render json: @notification.new_attr
        else
            render json: @notification.errors, status: :unprocessable_entity
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
    end

    def notification_params
        params.require(:notification).permit(
         :title, :description, :note_id, :profile_id)
    end
end
