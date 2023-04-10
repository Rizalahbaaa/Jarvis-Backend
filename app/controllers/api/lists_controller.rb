class Api::ListsController < ApplicationController
  before_action :set_list, only: %i[show update destroy]

  def index
    # binding.pry
    @list = List.all
    render json: { success: true, status: 200, data: @list.map {|list| list.new_attributes} }
  end

  def show
    render json: @list.new_attributes
  end

  def create
    @list = List.new(list_params)

    if @list.save
      render json: @list.new_attributes, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def update
    if @list.update(list_params)
      render json: @list.new_attributes
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @list.destroy
      render json: { message: 'success to delete teams' }, status: 200
    else
      render json: { message: 'failed to delete teams' }, status: 422
    end
  end

  private

  def set_list
    @list = List.find_by_id(params[:id])
    return unless @list.nil?

    render json: { error: 'List not found' }, status: :not_found
  end

  def list_params
    params.permit(
      :title,
      :team_id
    )
  end
end
