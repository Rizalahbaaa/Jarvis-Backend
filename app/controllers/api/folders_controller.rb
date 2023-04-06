class Api::FoldersController < ApplicationController
    before_action :set_folder, only: [:create, :update, :destroy]
  
    def index
      @folders = Folder.all
      render json: { message: "success", data: @folders }, status: :ok
    end
  
    def create
      @folder = Folder.new(folder_params)
      if @folder.save
        render json: { message: "success", data: @folder }, status: :created
      else
        render json: { message: @folder.errors }, status: :unprocessable_entity
      end
    end
  
    def update
        if @folder.update(folder_params)
          render json: { message: "success", data: @folder }, status: :ok
        else
          render json: { message: @folder.errors }, status: :unprocessable_entity
        end
    end
      
  
    def destroy
      if @folder.destroy
        render json: { message: "success", data: @folder }, status: :ok
      else
        render json: { message: @folder.errors }, status: :unprocessable_entity
      end
    end
  
    private
    def set_folder
      @folder = Folder.find_by(id: params[:id])
      return render json: { message: "File not found" }, status: :not_found if @folder.nil?
    end
  
    def folder_params
      params.require(:folder).permit(:name, :folder, :progress_id)
    end
end