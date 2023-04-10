class Api::ProgressController < ApplicationController
    before_action :set_progress, only: [:create, :update, :destroy]
  
    def index
      @progresses = Progress.all
      render json: { message: "success", data: @progresses }, status: :ok
    end
  
    def create
      @progress = Progress.new(message_params)
      if @progress.save
        render json: { message: "success", data: @progress }, status: :created
      else
        render json: { message: @progress.errors }, status: :unprocessable_entity
      end
    end
  
    def update
        if @progress.update(progress_params)
          render json: { message: "success", data: @progress }, status: :ok
        else
          render json: { message: @progress.errors }, status: :unprocessable_entity
        end
    end
      
  
    def destroy
      if @progress.destroy
        render json: { message: "success", data: @progress }, status: :ok
      else
        render json: { message: @progress.errors }, status: :unprocessable_entity
      end
    end
  
    private
    def set_progress
      @progress = Progress.find(params[:id])
      return render json: { message: "Progress not found" }, status: :not_found if @progress.nil?
    end
  
    def message_params
      params.require(:progress).permit(:status, :notes_id, :user_id)
    end
end