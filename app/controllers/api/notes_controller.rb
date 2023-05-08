class Api::NotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_note, only: %i[update destroy]

  def index
    @notes = Note.ownersfilter(current_user)
    render json: { success: true, status: 200, data: @notes.map { |note| note.new_attr } }
  end

  # def create
  #   @note = Note.create(note_params)
  #   @user = current_user
  #   @user_note = @user.user_notes.build(usernote_params)
  #   @user_note.note = @note
  #   if @note.save && @user_note.save
  #     render json: { success: true, message: 'note created successfully', status: 201, data: @note.new_attr },
  #            status: 201
  #   else
  #     render json: { success: false, message: 'note created unsuccessfully', status: 422, data: @note.errors, test:@user_note.errors},
  #            status: 422
  #   end
  # end

  def create
    # @user = current_user
    @note = Note.new(note_params)
    return unless @note.save

    @user_note = UserNote.new(note: @note, user: @current_user)
    if @user_note.save
      collab_mailer
      render json: { success: true, message: 'note created successfully', status: 201, data: @note.new_attr },
             status: 201
    else
      render json: { success: false, message: 'note created unsuccessfully', status: 422, data: @note.errors },
             status: 422
    end
  end

  def email_valid
    @email = params[:email].downcase
    return @email.errors if @email.blank?

    @results = User.all.where('LOWER(email) LIKE ?', @email)
    @results.each do |result|
      result.email
    end
    render json: { data: @results.map { |result| result.email } }, status: 200
  end

  def collab_mailer
    @emails = params[:email]
    return unless @emails.present?

    @note.update(note_type: 1)
    @emails.each do |email|
      token = set_invite_token
      @user_invite = User.find_by(email: email)
      @invite_collab = UserNote.new(note: @note, user: @user_invite, noteinvitation_token: token[:token], noteinvitation_status:
        token[:status], role: token[:role], noteinvitation_expired: token[:expired])
      if @invite_collab.save
        puts 'SENDING EMAIL.....'
        InvitationMailer.invitation_email(email, token[:token]).deliver_now
      end
      # binding.pry
    end
  end

  # def update
  #   @noteid = Note.notefunc(@note)
  #   if @noteid.owners?(current_user) != true
  #     render json: { success: false, status: 422, message: 'only owner can update note' }
  #  elsif @noteid.owners?(current_user) == true && @note.update(note_params)
  #     render json: { success: true, message: 'note updated successfully', status: 200, data: @note.new_attr },
  #            status: 200
  #  elsif
  #     render json: { success: false, message: 'note updated unsuccessfully', status: 422, data: @note.errors },
  #            status: 422
  #   end
  # end

  def update
    @user_note = UserNote.find_by(user: @current_user, note: @note)
    # binding.pry
    if @user_note.role != 'owner'
      render json: { success: false, message: 'sorry, only owner can update note', status: 422 },
              status: 422
    elsif @user_note.role == 'owner' && @user_note.user_id != @user.id && @note.update(note_params)
      render json: { success: true, message: 'note updated successfully', status: 200, data: @note.new_attr },
              status: 200
    else
      if @noteid.owners?(current_user) == true && @note.update(note_params)
        render json: { success: true, message: 'note updated successfully', status: 200, data: @note.new_attr },
               status: 200
      else
        render json: { success: false, message: 'note updated unsuccessfully', status: 422, data: @note.errors },
               status: 422
      end
    end
  end

  # def destroy
  #   @noteid = Note.notefunc(@note)
  #   if @noteid.owners?(@current_user) != true & @email_found
  #     render json: { success: false, status: 422, message: 'only owner can delete note' }
  #   elsif @noteid.owners?(@current_user) == true && @note.destroy
  #     render json: { success: true, status: 200, message: 'note deleted successfully' }, status: 200
  #   end
  # end

  def destroy
    @user_note = UserNote.find_by(user: @current_user, note: @note)
    # binding.pry
    if @user_note.role != 'owner'
      render json: { success: false, message: 'sorry, only owner can delete note', status: 422 },
              status: 422
    elsif @user_note.role == 'owner' && @user_note.user_id != @user.id && @note.destroy
      render json: { success: true, message: 'note delete successfully', status: 200 },
              status: 200
    else
      render json: { success: false, message: 'note delete unsuccessfully', status: 422, data: @note.errors },
              status: 422
    end
  end
# def complete!(user_note)

  #   Transaction.create!(user_id: user_note.user_id, point: 1, point_type: 'earned', user_note_id: user_note.id, transaction_status: 2)
  # end
  
  # def complete_notes
  #   @note.user_note.each do |user_note|
  #     complete!(user_note)
  #   end
  # end
  private

  def set_invite_token
    {
      token: SecureRandom.hex(20),
      status: 0,
      role: 1,
      expired: Time.now + 1.day
    }
  end

  def set_note
    @note = Note.find_by_id(params[:id])
    return unless @note.nil?

    render json: { status: 404, message: 'note not found' }, status: 404
  end

  def note_params
    params.require(:note).permit(:subject, :description, :event_date, :reminder, :ringtone_id, :column_id, :note_type,
                                 :status)
  end

end