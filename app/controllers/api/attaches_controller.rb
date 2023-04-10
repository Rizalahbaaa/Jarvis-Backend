class Api::AttachesController < ApplicationController
    # before_action :set_attach, only: [:create, :update, :destroy]
      
    def index
        @attaches = Attach.all
        render json: { message: "success", data: @attaches }, status: :ok
    end
      
    def create
        @attach = Attach.new(attach_params)
        if @attach.save
            render json: { message: "success", data: @attach }, status: :created
        else
            render json: { message: @attach.errors }, status: :unprocessable_entity
        end
    end
      
    def update
        if @attach.update(attach_params)
            render json: { message: "success", data: @attach }, status: :ok
        else
            render json: { message: @attach.errors }, status: :unprocessable_entity
        end
    end
          
      
    def destroy
        if @attach.destroy
            render json: { message: "success", data: @attach }, status: :ok
        else
            render json: { message: @attach.errors }, status: :unprocessable_entity
        end
    end
      
    private
    def set_attach
        @attach = Attach.find_by(id: params[:id])
        return render json: { message: "File not found" }, status: :not_found if @attach.nil?
    end
      
    def attach_params
        params.require(:attach).permit(:name, :path, :progress_id)
    end
end