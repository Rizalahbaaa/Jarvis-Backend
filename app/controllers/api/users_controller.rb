class Api::UsersController < ApplicationController
  before_action :set_user, only: %i[destroy update]
  def index
    @users = User.all
    if @users.present?
      render json: { success: true, message: 'data found', status: 200, data: @users.map { |user| user.new_attr} }
    else
      render json: { success: true, message: 'data not found', status: 404 }, status: 404
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      render json: { success: true, status: 201, message: 'create account successfully', data: @user.new_attr }, status: 201
    else
      render json: { success: false, status: 422, message: 'create account unsuccessfully', data: @user.errors }, status: 422
    end
  end

  def update
    if @user.update(user_params)
      render json: { success: true, status: 200, data: @user.new_attr }, status: 200
    else
      render json: { success: false, status: 422, message: @user.errors }, status: 422
    end
  end

  def destroy
    if @user.destroy
      render json: { success: true, status: 200, message: 'user deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'user deleted unsuccessfully' }, status: 422
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
    return unless @user.nil?

    render json: { status: 404, message: 'user not found' }, status: 404
  end

  def user_params
    params.require(:user).permit(:username, :email, :phone, :job, :password, :password_confirmation)
  end
end
