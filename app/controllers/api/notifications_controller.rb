class Api::NotificationsController < ApplicationController
    before_action :authenticate_request
    before_action :set_notification, only: %i[update destroy show]
    
    def index
        notifs = Notification.where(user_id: current_user.id).order(created_at: :desc)

        render json: { success: true, status: 200, data: notifs.map {|n| n.new_attr} }
    end

    def user_notif
        @notifications = Notification.where(user_id: current_user.id, notif_type: 0).order(created_at: :desc)
        render json: { success: true, status: 200, data: @notifications.map { |notification| notification.new_attr } } 
    end
    
      
    def create
        @notification = Notification.new(notification_params)
        @notification.user_id = current_user.id
        if @notification.save
          render json: { success: true, message: 'notification sent successfully', status: 201, data: @notification.new_attr },
                 status: 201
        else
          render json: { success: false, message: 'notification sending unsuccessful', status: 422, data: @notification.errors },
                 status: 422
        end
      end      

    def mark_as_read
        @notification = Notification.find(params[:id])
        if @notification.update(read: true)
          render json: { success: true }
        else
          render json: { success: false }
        end
    end
    
    def update
        if @notification.update(notification_params)
            render json: { success: true, message: 'notification updated successfully', status: 200, data: @notifications.new_attr },
             status: 200
        else
        render json: { success: false, message: 'notification updated unsuccessfully', status: 422, data: @notifications.errors },
                status: 422
        end
    
    end
    
    def destroy
        @notification = Notification.find(params[:id])
        if @notification.destroy
            render json: { success: true, status: 200, message: 'notification deleted successfully' }, status: 200
        else
            render json: { success: true, status: 422, message: 'notification deleted unsuccessfully' }, status: 422
        end
    end
    
    private

    def set_notification
        @notification = Notification.find(params[:id])
        return unless @notification.nil?
    
        render json: { status: 404, message: 'notification not found' }, status: 404
    end

    def notification_params
        params.require(:notification).permit(:title, :body, :user_id, :read)
    end
    
end
