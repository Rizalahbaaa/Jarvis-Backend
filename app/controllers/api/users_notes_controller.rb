class Api::UsersNotesController < ApplicationController
  before_action :set_usernote, only: %i[ show update destroy ]
  before_action :authenticate_request, except: %i[accept_invitation decline_invitation]
  def index
    @user_notes = UserNote.all
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end

  def on_progress
    @user_notes = UserNote.where(status: "on_progress")
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end
  
  def completed
    @user_notes = UserNote.where(status: "completed")
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end

  def late
    @user_notes = UserNote.where(status: "late")
    render json: { success: true, status: 200, data: @user_notes.map {|user_note| user_note.new_attr} }
  end

  def create
    # Cari user dengan email yang sesuai
    @emails = Array(params[:email])
    @user_ids = []
    @errors = []
    @existing_user_ids = UserNote.where(note_id: params[:note_id], noteinvitation_status: 1).pluck(:user_id)

    @emails.each do |email|
      @user = User.find_by(email: email.strip) #variable buat cari email | strip untuk
  
      if @user #ngejalanin fungsi variable @usesr
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
        usernote_params_hash = usernote_params(user_id, params[:note_id])
        @user_note = UserNote.new(usernote_params_hash)
  
        if @user_note.save
          # Kirim email undangan ke user
          InvitationMailer.invitation_email(@user_note).deliver_now
          @user_notes << @user_note
        else
          errors = @user_note.errors.full_messages.join(", ")
          render json: { message: "Gagal", errors: @user_note.errors.full_messages }
          return
        end
      end
      render json: { status: 201, message: "Undangan Terkirim"}, status: 201
    else
      # Kirim pesan kesalahan jika ada email yang belum terdaftar
      render json: { status: 404, message: @errors.join(', ') }, status: :not_found
    end
  end

  def usernote_params(user_id, note_id)
    {
      user_id: user_id,
      note_id: note_id,
      role: 1,
      noteinvitation_token: SecureRandom.hex(20),
      noteinvitation_status: 0,
      noteinvitation_expired: Time.now + 1.days
    }
  end

  def accept_invitation
    @user_note = UserNote.find_by(noteinvitation_token: params[:noteinvitation_token])

    if @user_note && @user_note.invitation_valid?
      @user_note.accept_invitation!
      render json: { status: 200, message: "Undangan Diterima"}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
    end 
  end

  def decline_invitation
    @user_note = UserNote.find_by(noteinvitation_token: params[:noteinvitation_token])

    if @user_note && @user_note.invitation_valid?
      @user_note.decline_invitation!
      render json: { status: 200, message: "Undangan Ditolak", data:@user_note}, status: 200
    else
      render json: { message: "Undangan tidak valid"}
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
    
  end

  private

  # def user_note_params
  #   params.require(:users_note).permit(:note_id, :user_id, :reminder, :role, :status)
  # end

  def set_usernote
    @user_note = Usernote.find_by(id: params[:id])
    return render json: { status:404, message: "User Team Tidak ditemukan", data: []}, status: :not_found if@user_note.nil?
  end


  # def noteinvite_params
  #   params.require(:users_note).permit(:note_id, :user_id, :noteinvitation_token)
  # end
  
end
