class Api::NotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_note, only: %i[update destroy show]

  def index
    notes = Note.filter_and_sort(params, current_user)
    if notes.present?
      render json: { success: true, message: 'data found', status: 200, data: notes.map do |owner|
                                                                                owner.new_attr
     end }
    else
      render json: { success: true, message: 'data not found', status: 404 }, status: 404
    end
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
      end
      return render json: { success: true, message: 'note created successfully', status: 201, data: @note.new_attr },
             status: 201
    else
      return render json: { success: false, message: 'note created unsuccessfully', status: 422, data: @note.errors },
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
          InvitationMailer.collab_invitation(email, token[:token]).deliver_now
        end
      else
        render json: { status: 422, message: "#{email} already invited" }, status: 422
      end
    end
  end

  def update
    if params[:note_type] && @note.note_type != params[:note_type]
      return render json: { success: false, message: 'cannot change note_type', status: 400 }, status: :bad_request
    end
  
    @find_user_note = UserNote.find_by(user: @current_user, note: @note)
    if (@find_user_note.role == 'owner' && @find_user_note.user_id != @current_user) || (!@note.column_id.nil? && Note.teamates(@current_user, @note))
      emails = params[:email]
  
      if emails.present?
        collab_mailer
        return render json: { status: 200, message: 'email sent successfully' }, status: 200
      end
  
      if @note.update(note_params)
        @find_user_note.update(updated_at: Time.now)
        @note = Note.find(params[:id])
        note_members = @note.users
        recipients = []
  
        note_members.each do |member|
          unless emails&.include?(member.email)
            Notification.create(
              title: "Telah memperbarui Catatan #{@note.subject}",
              body: params[:body],
              user_id: member.id,
              sender_id: current_user.id,
              sender_place: @note.id
            )
            recipients << member.email
          end
        end     
        render json: { success: true, status: 200, message: 'note updated successfully', data: @note.new_attr },
               status: 200
      else
        render json: { success: false, status: 422, message: 'note updated unsuccessfully', data: @note.errors },
               status: 422
      end
    else
      render json: { success: false, message: 'sorry, only the owner can update the note', status: 422 },
             status: 422
    end
  end  

  def destroy
    @user_note = UserNote.find_by(user: @current_user, note: @note)
    
    if @user_note.role != 'owner'
      render json: { success: false, message: 'sorry, only owner can delete note', status: 422 },
             status: 422
    elsif @note.destroy
      note_members = @note.users
      note_members.each do |member|
        unless member == @current_user
          notification = Notification.new(
            title: "Telah menghapus Catatan #{@note.subject}",
            body: params[:body],
            user_id: member.id,
            sender_id: @current_user.id,
            sender_place: @note.id
          )
          notification.save
        end
      end
  
      render json: { success: true, message: 'note deleted successfully', status: 200 },
             status: 200
    else
      render json: { success: false, message: 'note deletion unsuccessful', status: 422, data: @note.errors },
             status: 422
    end
  end
  
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
    params.permit(:subject, :description, :event_date, :reminder, :ringtone_id, :column_id,
                  :status)
  end

  def attach_params
    params.permit({path: []})
  end
end
