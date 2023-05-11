class Api::NotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_note, only: %i[update destroy show]
  rescue_from ActionController::UnpermittedParameters, with: :handle_errors

  def index
    @notes = Note.ownersfilter(current_user)
    render json: { success: true, status: 200, data: @notes.map { |note| note.new_attr } }
  end

  def show
    render json: { success: true, status: 200, data: @note.new_attr }, status: 200
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      @user_note = UserNote.create(note: @note, user: @current_user)
      @emails = params[:email]
      if @emails.present?
        collab_mailer
        return
      end
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
    @note.update(note_type: 1)
    @emails.each do |email|
      token = set_invite_token
      @user_invite = User.find_by(email:)
      @is_join = UserNote.find_by(note: @note, user: @user_invite)
      if @is_join.nil?
        @invite_collab = UserNote.new(note: @note, user: @user_invite, noteinvitation_token: token[:token], noteinvitation_status:
          token[:status], role: token[:role], noteinvitation_expired: token[:expired])
        if @invite_collab.save
          puts 'SENDING EMAIL.....'
          InvitationMailer.invitation_email(email, token[:token]).deliver_now
        end
      else
        render json: { status: 422, message: "#{email} already invited" }, status: 422
      end
    end
    render json: { status: 200, message: 'email send successfully' }, status: 200
    return
  end

  def update
    @find_user_note = UserNote.find_by(user: @current_user, note: @note)
    if @find_user_note.role == 'owner' && @find_user_note.user_id != @current_user
      @emails = params[:email]

      if @emails.present?
        collab_mailer
        return
      end

      if @note.update(note_params)
        render json: { success: true, status: 200, message: 'note updated successfully', data: @note.new_attr },
        status: 200
      else
        render json: { success: false, status: 422, message: 'note updated unsuccessfully', data: @note.errors },
               status: 422
      end
    else
      render json: { success: false, message: 'sorry, only owner can update note', status: 422 },
             status: 422
    end
  end

  def destroy
    @user_note = UserNote.find_by(user: @current_user, note: @note)
    # binding.pry
    if @user_note.role != 'owner'
      render json: { success: false, message: 'sorry, only owner can delete note', status: 422 },
             status: 422
    elsif @user_note.role == 'owner' && @user_note.user_id != @current_user && @note.destroy
      render json: { success: true, message: 'note delete successfully', status: 200 },
             status: 200
    else
      render json: { success: false, message: 'note delete unsuccessfully', status: 422, data: @note.errors },
             status: 422
    end
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

  # def destroy
  #   @noteid = Note.notefunc(@note)
  #   if @noteid.owners?(@current_user) != true & @email_found
  #     render json: { success: false, status: 422, message: 'only owner can delete note' }
  #   elsif @noteid.owners?(@current_user) == true && @note.destroy
  #     render json: { success: true, status: 200, message: 'note deleted successfully' }, status: 200
  #   end
  # end

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
    params.require(:note).permit(:subject, :description, :event_date, :reminder, :ringtone_id, :column_id,
      :status)
    end

    def handle_errors
    # ActionController::Parameters.action_on_unpermitted_parameters = :raise
    render json: { "unpermitted parameters found": params.to_unsafe_h.except(:controller, :action, :note, :id, :subject,
                    :description, :event_date, :reminder, :ringtone_id, :column_id, :status).keys }, status: 422
  end
end
