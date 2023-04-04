class Api::UsersController < ApplicationController
  before_action :set_user, only: :destroy
  def index
    @users = User.all
    render json: @users.map { |user| user.new_attr }
  end

  def register
    @user = User.new(user_params)
    if @user.save
      render json: @user.new_attr, status: 201
    else
      render json: @user.errors, status: 422
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'success to delete user' }, status: 200
    else
      render json: { message: 'fail to delete user' }, status: 422
    end
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
    return unless @user.nil?

    render json: { error: 'user not found' }, status: 404
  end

  def user_params
    params.require(:user).permit(:username, :email, :phone, :job_id, :password, :password_confirmation)
  end
end
