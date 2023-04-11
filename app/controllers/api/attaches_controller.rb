class Api::AttachesController < ApplicationController
    before_action :set_attach, only: [:update, :destroy]
      
    def index
        @attaches = Attach.all
        render json: { success: true, status: 200, data: @attaches.map {|attach| attach.new_attr} }
    end
      
    def create
        @attach = Attach.new(attach_params)
        if @attach.save
            render json: { success: true, status: 201, data: @attach.new_attr }, status: 201
          else
            render json: { success: false, status: 422, message: @attach.errors }, status: 422
        end
    end
      
    def update
        if @attach.update(attach_params)
            render json: { success: true, status: 200, data: @attach.new_attr }, status: 200
          else
            render json: { success: false, status: 422, message: @attach.errors }, status: 422
        end
    end
          
      
    def destroy
        if @attach.destroy
            render json: { success: true, status: 200, message: 'File deleted successfully' }, status: 200
          else
            render json: { success: true, status: 422, message: 'File deleted unsuccessfully' }, status: 422
        end
    end
      
    private
    def set_attach
        @attach = Attach.find(params[:id])
        return render json: { message: "File not found" }, status: :not_found if @attach.nil?
    end
      
    def attach_params
        params.require(:attach).permit(:name, :path, :progress_id)
    end
end