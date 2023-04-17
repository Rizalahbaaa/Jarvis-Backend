class Api::ColumnsController < ApplicationController
  before_action :set_column, only: %i[show update destroy]

  def index
    # binding.pry
    @column = Column.all
    render json: { success: true, status: 200, data: @column.map {|column| column.new_attributes} }
  end

  def show
    render json: @column.new_attributes
  end

  def create
    @column = Column.new(column_params)

    if @column.save
      render json: @column.new_attributes, status: :created
    else
      render json: @column.errors, status: :unprocessable_entity
    end
  end

  def update
    if @column.update(column_params)
      render json: @column.new_attributes
    else
      render json: @column.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @column.destroy
      render json: { message: 'success to delete column' }, status: 200
    else
      render json: { message: 'failed to delete column' }, status: 422
    end
  end

  private

  def set_column
    @column = Column.find_by_id(params[:id])
    return unless @column.nil?

    render json: { error: 'Column not found' }, status: :not_found
  end

  def column_params
    params.permit(
      :title,
      :team_id
    )
  end
end
