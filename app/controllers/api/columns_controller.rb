class Api::ColumnsController < ApplicationController
  before_action :set_column, only: %i[show update destroy]

  def index
    @team = Team.find(params[:team_id]) # Ubah ini sesuai dengan cara Anda mendapatkan ID tim yang diinginkan
    @columns = @team.column # Ambil semua kolom yang terkait dengan tim
  
    render json: { success: true, status: 200, data: @columns.map { |column| column.new_attr(current_user) } }
  end

  def show
    render json: @column.new_attr(current_user)
  end

  def create
    @column = Column.new(column_params)

    if @column.save && Column.teamsval(current_user, params[:team_id])
      render json: { success: true, status: 201, message: 'create column successfully', data: @column.new_attr(current_user) },
             status: 201
    else
      render json: { success: false, status: 422, message: 'create column unsuccessfully', data: @column.errors },
             status: 422
    end
  end

  def update
    if params[:team_id] && @column.team_id != params[:team_id]
      return render json: { success: false, message: 'cannot change team id', status: 400 }, status: :bad_request
    end
    if @column.update(column_params) 
      render json: { success: true, status: 200, message: 'column updated successfully', data: @column.new_attr(current_user) }, status: 200
    else
      render json: { success: false, status: 422, message: @column.errors }, status: 422
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
