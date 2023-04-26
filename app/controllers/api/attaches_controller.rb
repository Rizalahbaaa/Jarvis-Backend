class Api::AttachesController < ApplicationController
    before_action :set_attach, only: [:update, :destroy]
      
    def index
        @attaches = Attach.all
        render json: { success: true, message: 'data found', status: 200, data: @attaches.map {|attach| attach.new_attr} }
    end
      
    def create
        @attach = Attach.new(attach_params)
        if @attach.save
            render json: { success: true, message: 'file uploaded successfully', status: 201, data: @attach.new_attr }, status: 201
          else
            render json: { success: false, message: 'file uploaded unsuccessfully', status: 422, data: @attach.errors }, status: 422
        end
    end

    def show
        render json: @attach.new_attr
    end
      
    def update
        if @attach.update(attach_params)
            render json: { success: true, message: 'file updated successfully', status: 200, data: @attach.new_attr }, status: 200
          else
            render json: { success: false, message: 'file updated unsuccessfully' ,status: 422, data: @attach.errors }, status: 422
        end
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
        render json: { status: 404, message: "file not found" }, status: 404
    end
      
    def attach_params
        params.require(:attach).permit(:name, :path, :user_note_id)
    end
end
