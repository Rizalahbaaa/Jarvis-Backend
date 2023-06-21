class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create login confirm_email forgot reset resend_verification]
  before_action :set_user, only: %i[show update destroy update_password]

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
      puts 'SENDING EMAIL.....'
      UserMailer.registration_confirmation(@user).deliver_now
      new_transaction = @user.transactions.create(point:0, point_type: 'earned')
      new_transaction.save
      @user.add_notes_count(100) # Ubah angka 3 sesuai dengan jumlah catatan yang ingin ditambahkan
      render json: { success: true, status: 201, message: 'please confirm your email address to continue', data: @user.new_attr },
             status: 201
    else
      render json: { success: false, status: 422, message: 'oooppss, something went wrong!', data: @user.errors.full_messages.first },
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
          status: 403, message: 'Please activate your email account first'
        }, status: 403
      end
    else
      render json: { error: 'invalid email or password' }, status: 401
    end
  end

  def show
    render json: current_user.new_attr
  end

  def active_user
    render json: {success: true, status: 200, data: @current_user.new_attr}, status: 200
  end

  def update
    if @user.update(user_update)
      render json: { success: true, message: 'profile updated successfully', status: 200, data: @user.new_attr },
             status: 200
    else
      render json: { success: false, message: 'profile updated unsuccessfully', status: 422, data: @user.errors },
             status: 422
    end
  end

  def destroy
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

  def resend_verification
    user = User.find_by(email: params[:email])

    if user.present? && user.email_confirmed.nil?
      puts 'SENDING EMAIL.....'
      UserMailer.resend_email_verification(user).deliver_now
      render json: {status: 200, message: 'please confirm your email'}, status: 200
    elsif user.present? && user.email_confirmed == true
      render json: {status: 200, message: 'your email has been verified'}, status: 200
    else
      render json: {status: 404, message: 'email not found'}, status: 404
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
      if @user.update(user_params.merge(is_forgot: true))
        render json: { message: 'password has been reset!' }, status: 200
      else
        render json: { status: '422', error: @user.errors }, status: 422
      end
    else
      render json: { status: '404', error: 'Link not valid or expired. Try generating a new link.' }, status: 404
    end
  end

  def check_reset
    token = params[:token]

    @user = User.find_by(password_reset_token: token)

    if @user.present? && @user.password_token_valid?
      render json: { status: '200', message: 'Link is valid'}, status: 200
    else
      render json: { status: '404', error: 'Link not valid or expired. Try generating a new link.' }, status: 404
    end
  end

  def update_password
    unless @user.authenticate(params[:current_password])
      render json: { success: false, message: 'Invalid current password', status: 422 }, status: 422
      return
    end

    if @user.update(password_params.merge(is_forgot: true))
      render json: { success: true, message: 'Password updated successfully', status: 200 }, status: 200
    else
      render json: { success: false, message: 'Failed to update password', status: 422, errors: @user.errors.full_messages }
    end
  end
  def point
    user = User.find_by(id: params[:id])
    point = user.point
    render json: { success: true, status: 200, message: 'User point retrieved successfully', data: { user_id: user.id, point: point } }
  end

  def notes_count
    user = User.find_by(id: params[:id])
    notes_count = user.notes_countJago
    render json: { success: true, status: 200, message: 'User note retrieved successfully', data: { user_id: user.id, notes_count: notes_count } }
  end
    
  private

  def set_user
    @user = current_user
    # @user = User.find(params[:id])
    return unless @user.nil?

    render json: { status: 404, message: 'user not found' }, status: 404
  end

  def user_params
    params.permit(:username,:email, :phone, :job, :photo, :password, :password_confirmation, :notes_count)
  end

  def user_update
    params.permit(:username, :phone, :job, :photo, :password, :password_confirmation, :notes_count)
  end
  

  def password_params
    params.permit(:current_password, :password, :password_confirmation)
  end


end
