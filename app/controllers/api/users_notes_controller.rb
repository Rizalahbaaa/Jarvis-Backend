class Api::UsersNotesController < ApplicationController
  def index
    @user_notes = UserNote.all
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end

  def create
    @user_note = UserNote.new(user_note_params)
    if @user_note.save
      render json: { success: true, status: 201, data: @user_note.new_attr }, status: 201
    else
      render json: { success: false, status: 422, data: @user_note.errors }, status: 422
    end
  end

  def destroy
    @user_note = UserNote.find_by_id(params[:id])
    if @user_note.destroy
      render json: { success: true, status: 200, message: 'user_note deleted successfully' }, status: 200
    else
      render json: { success: true, status: 422, message: 'user_note deleted unsuccessfully' }, status: 422
    end
  end

  def invite
    # Cari user dengan email yang sesuai
    @emails = Array(params[:email])
    @user_ids = []
    @errors = []
    @existing_user_ids = Usernote.where(team_id: params[:note_id], invitation_status: 1).pluck(:user_id)

    @emails.each do |email|
      @user = User.find_by(email: email.strip)
  
      if @user
        if @existing_user_ids.include?(@user.id)
          # User sudah terdaftar dalam tim, tambahkan pesan error ke dalam array
          @errors << "#{email} sudah terdaftar dalam tim"
        else
          # User belum terdaftar dalam tim, tambahkan user_id ke dalam array
          @user_ids << @user.id
        end
      else
        # Tambahkan pesan kesalahan ke dalam array jika user tidak ditemukan
        @errors << "#{email} belum terdaftar"
      end
    end

    if @errors.present?
      render json: { status: 422, message: @errors.join(', ') }, status: :unprocessable_entity
      return
    end

    if @errors.empty?
      # Buat data baru pada tabel User_Tim untuk setiap user_id
      @user_notes = []
      @user_ids.each do |user_id|

        usernite_params_hash = usernote_params(user_id, params[:note_id])
        @user_note = Usernote.new(usernote_params_hash)
  
        if @user_note.save
          # Kirim email undangan ke user
          InvitationMailer.invitation_email(@user_note).deliver_now
          @user_notes << @user_note
        else
          render json: { message: "Gagal", errors: @user_note.errors.full_messages }
          return
        end
      end
  
      render json: { status: 201, message: "Terbuat", data: @user_notes }, status: 201
    else
      # Kirim pesan kesalahan jika ada email yang belum terdaftar
      render json: { status: 404, message: @errors.join(', ') }, status: :not_found
    end
  end

  def usernote_params(user_id, note_id)
    {
      user_id: user_id,
      note_id: note_id,
      noteinvitation_token: SecureRandom.hex(20),
      noteinvitation_status: 0,
      noteinvitation_expired: Time.now + 15.minutes
    }
  end

  def accept_invitation
    @user_note = Usernote.find_by(noteinvitation_token: params[:noteinvitation_token])

    if @user_note && @user_note.invitation_valid?
      @user_note.accept_invitation!
      render json: { status: 200, message: "Undangan Diterima", data:@user_note}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def decline_invitation
    @user_note = Usernote.find_by(noteinvitation_token: params[:noteinvitation_token])

    if @user_note && @user_note.invitation_valid?
      @user_note.decline_invitation!
      render json: { status: 200, message: "Undangan Ditolak", data:@user_note}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  private

  def user_note_params
    params.require(:users_note).permit(:note_id, :user_id, :reminder, :role, :status)
  end

  # def noteinvite_params
  #   params.require(:users_note).permit(:note_id, :user_id, :noteinvitation_token)
  # end
  
end
