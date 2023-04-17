class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[register login]
  before_action :set_user, only: %i[destroy show update]

  def index
    @users = User.all
    if @users.present?
      render json: { success: true, message: 'data found', status: 200, data: @users.map { |user| user.new_attr } }
    else
      render json: { success: true, message: 'data not found', status: 404 }, status: 404
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      render json: { success: true, status: 201, message: 'create account successfully', data: @user.new_attr },
             status: 201
    else
      render json: { success: false, status: 422, message: 'create account unsuccessfully', data: @user.errors },
             status: 422
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: {
        success: true, status: 201, message: 'login successfully',
        data: @user.new_attr,
        token:
      }, status: 200
    else
      render json: { error: 'invalid email or password' }, status: 401
    end
  end

  def show
    render json: @user.new_attr
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
    @user = User.find_by_id(current_user)
    return unless @user.nil?

    render json: { status: 404, message: 'user not found' }, status: 404
  end

  def user_params
    params.require(:user).permit(:username, :email, :phone, :job, :password, :password_confirmation)
  end
end
