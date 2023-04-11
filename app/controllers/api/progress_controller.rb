class Api::ProgressController < ApplicationController
    before_action :set_progress, only: [:update, :destroy]
  
    def index
      @progresses = Progress.all
      render json: { success: true, status: 200, data: @progresses.map {|progress| progress.new_attr} }
    end
  
    def create
      @progress = Progress.new(progress_params)
      if @progress.save
        render json: { success: true, status: 201, data: @progress.new_attr }, status: 201
      else
        render json: { success: false, status: 422, message: @progress.errors }, status: 422
      end
    end
  
    def update
      if @progress.update(progress_params)
        render json: { success: true, status: 200, data: @progress.new_attr }, status: 200
      else
        render json: { success: false, status: 422, message: @progress.errors }, status: 422
      end
    end
      
  
    def destroy
      if @progress.destroy
        render json: { success: true, status: 200, message: 'Progress deleted successfully' }, status: 200
      else
        render json: { success: true, status: 422, message: 'Progress deleted unsuccessfully' }, status: 422
      end
    end
  
    private
    def set_progress
      @progress = Progress.find(params[:id])
      return render json: { message: "Progress not found" }, status: :not_found if @progress.nil?
    end
  
    def progress_params
      params.require(:progress).permit(:status, :note_id, :profile_id)
    end
end