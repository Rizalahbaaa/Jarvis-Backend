class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[index destroy create login confirm_email forgot reset]
  before_action :set_user, only: %i[show update]

  def index
    @users = User.all
    if @users.present?
      render json: { success: true, message: 'data found', status: 200, data: @users.map { |user| user.new_attr } }
    else
      render json: { success: true, message: 'data not found', status: 404 }, status: 404
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      render json: { success: true, status: 201, message: 'please confirm your email address to continue', data: @user.new_attr },
             status: 201
    else
      render json: { success: false, status: 422, message: 'oooppss, something went wrong!', data: @user.errors },
             status: 422
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      if @user.email_confirmed
        token = JsonWebToken.encode(user_id: @user.id)
        render json: {
          success: true, status: 200, message: 'login successfully',
          data: @user.new_attr,
          token:
        }, status: 200
      else
        render json: {
          status: 422, message: 'Please activate your email account first'
        }, status: 422
      end
    else
      render json: { error: 'invalid email or password' }, status: 401
    end
  end

  def show
    render json: @user.new_attr
  end

  def update
    if @user.update(user_params)
      render json: { success: true, message: 'profile updated successfully', status: 200, data: @user.new_attr },
             status: 200
    else
      render json: { success: false, message: 'profile updated unsuccessfully', status: 422, data: @user.errors },
             status: 422
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { success: true, status: 200, message: 'user deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'user deleted unsuccessfully' }, status: 422
    end
  end

  def confirm_email
    @user = User.find_by_confirm_token(params[:id])
    if @user
      @user.email_activate
      render json: { message: 'email verified' }
    else
      render json: { message: 'Sorry. your email not verified' }
    end
  end

  def forgot
    return render json: { error: 'email not present' } if params[:email].blank?

    @user = User.find_by(email: params[:email])

    if @user.present?
      @user.generate_password_token!
      UserMailer.forgot_password(@user).deliver_now
      render json: { status: '200', message: 'E-mail sent with password reset instructions.' }, status: 200
    else
      render json: { error: 'email address not found. please check and try again.' }, status: 404
    end
  end

  def reset
    token = params[:token]

    @user = User.find_by(password_reset_token: token)

    if @user.present? && @user.password_token_valid?
      if @user.update(user_params)
        render json: { status: '200', message: 'password has been reset!' }, status: 200
      else
        render json: { status: '422', error: @user.errors }, status: 422
      end
    else
      render json: { status: '404', error: 'Link not valid or expired. Try generating a new link.' }, status: 404
    end
  end

  private

  def set_user
    @user = current_user
    return unless @user.nil?

    render json: { status: 404, message: 'user not found' }, status: 404
  end

  def user_params
    params.permit(:username, :email, :phone, :job, :photo, :password, :password_confirmation)
  end

end
