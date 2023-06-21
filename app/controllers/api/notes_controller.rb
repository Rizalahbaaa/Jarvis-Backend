class Api::NotesController < ApplicationController
  before_action :authenticate_request
  before_action :set_note, only: %i[update destroy show]

  def index
    notes = Note.filter_and_sort(params, current_user)
      render json: { success: true, status: 200, data: notes.map do |owner| owner.new_attr(current_user)
     end }
  end

  def show
    @find_user_note = UserNote.find_by(user: current_user, note: @note)
    if @note.note_type == 'team' && Note.teamates(current_user, @note)
      render json: { success: true, status: 200, data: @note.new_attr(current_user) }, status: 200
    elsif @find_user_note.role == 'member' && @find_user_note
      render json: { success: true, status: 200, data: @note.member_side(current_user)}, status: 200
    elsif @find_user_note.role == 'owner' && @find_user_note
      render json: { success: true, status: 200, data: @note.new_attr(current_user)}, status: 200
    end
  end

  def create
    @note = Note.new(note_params)
    column = params[:column_id]
    if !column.present? || Column.find_by(id: column).present? && Note.columncheck(current_user, column)
        if @current_user.can_create_note?
          if @note.save
        @current_user.deduct_notes_count(1) # Mengurangi notes_count
        @user_note = UserNote.create(note: @note, user: @current_user)

       emails = params[:email]
       if emails.present?
        collab_mailer(emails)
        @note.update(note_type: 1)
      #  elsif emails.present? && @note.note_type == 'team'
      #    Note.assign_member_to_note(emails, column, @note)
       end

       return render json: { success: true, message: 'Note created successfully', status: 201, data: @note.new_attr(current_user) },
       status: 201
        else
       return render json: { success: false, message: 'Note created unsuccessfully', status: 422, data: @note.errors },
     status: 422
       end
        else
          return render json: { success: true, message: 'Tidak Bisa membuat note lagi silahkan redeem', status: 422, data: @note.errors },
          status: 422
        end
        else 
       return render json: { success: false, message: 'cannot created note, your not tim member', status: 422 },
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

  def collab_mailer(emails)
    emails.each do |email|
      token = set_invite_token
      @user_invite = User.find_by(email:)
      @invite_collab = UserNote.new(note: @note, user: @user_invite, noteinvitation_token: token[:token], noteinvitation_status:
        token[:status], role: token[:role], noteinvitation_expired: token[:expired])
      if @invite_collab.save
        puts 'SENDING EMAIL.....'
        InvitationMailer.collab_invitation(email, token[:token]).deliver_now
      end
    end
  end

  def update
    not_invited = []
    if params[:note_type] && @note.note_type != params[:note_type]
      return render json: { success: false, message: 'cannot change note_type', status: 400 }, status: :bad_request
    end
  
    @find_user_note = UserNote.find_by(user: @current_user, note: @note)
    if (@find_user_note.role == 'owner' && @find_user_note) || (!@note.column_id.nil? && Note.teamates(@current_user, @note))
      emails = params[:email] || []
      if emails.present?
        emails.each do |e|
          user = User.find_by(email: e)
          is_join = UserNote.find_by(note: @note, user: user)
          if is_join.nil?
            not_invited << e
            # else
            #   return render json: { status: 422, message: "#{e} already invited" }, status: 422
          end
        end
        collab_mailer(not_invited)
        @note.update(note_type: 1)
      end

      # Mengambil record dari database
      record = Note.find_by(id: @note.id)
    
      # Menyimpan nilai kolom ke dalam variabel
      subject_value = record.subject
      description_value = record.description
      date_value = record.event_date
      reminder_value = record.reminder

      if @note.update(note_params)
        @find_user_note.update(updated_at: Time.now)
        note_members = @note.users

        if params[:email].present?
          default_message = "Telah Menambahkan Anggota Baru di Catatan #{@note.subject}"
        elsif subject_value != @note.subject
          default_message = "Telah Mengubah Nama Catatan #{subject_value} menjadi #{@note.subject}"
        elsif description_value != @note.description
          default_message = "Telah Mengubah Deskripsi Catatan #{@note.subject}"
        elsif date_value != @note.event_date
          default_message = "Telah Mengubah Tanggal Acara di Catatan #{@note.subject}"
        elsif reminder_value != @note.reminder
          default_message = "Telah Mengubah Tanggal Pengingat di Catatan #{@note.subject}"
        else
          default_message = "telah Memperbarui Catatan #{@note.subject}"
        end

        note_members.each do |member|
          if @note.note_type == 'collaboration'
            Notification.create(
              title: "#{default_message}",
              user_id: member.id,
              sender_id: current_user.id,
              sender_place: @note.id,
              place_name: @note.subject,
              body: params[:body]
            )
          elsif @note.note_type == 'team'
            Notification.create(
              title: "telah Memperbarui Catatan #{@note.subject}",
              user_id: member.id,
              sender_id: current_user.id,
              sender_place: @note.id,
              place_name: @note.subject,
              body: "#{current_user.username} #{default_message}"
            )
          end
        end
        return render json: { success: true, status: 200, message: 'note updated successfully', data: @note.new_attr(current_user) },
                status: 200
      else
        return render json: { success: false, status: 422, message: 'note updated unsuccessfully', data: @note.errors },
                status: 422
      end
    else
      render json: { success: false, message: 'sorry, only the owner can update the note', status: 422 },
             status: 422
    end
  end

  def completed_note
    note = Note.find_by(id: params[:id])
    if note.present?
      owner = UserNote.find_by(note: note, role: 'owner')
      if current_user.id == owner.user.id
        Note.note_done(note)
        earned_point = 100
        users = User.joins(:user_notes).where('user_notes.note_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', note.id, 1, 0)
        if users.present? && note.status == 'completed'
          users.each do |user|
            Transaction.create(
              user_id: user.id,
              point: earned_point,
              point_type: 'earned'
            )
          end
          return render json: { success: true, status: 201, message: "catatan selesai, mendapatkan #{earned_point} point" }, status: 201
        end
      else
        render json: { status: 422, message: 'maaf, anda bukan pemilik catatan' }, status: 422
      end
    else
      render json: { status: 404, message: 'catatan tidak ditemukan' }, status: 404
    end
  end
  
  
  def destroy
    @user_note = UserNote.find_by(user: @current_user, note: @note)
    
    if @user_note.role != 'owner'
      render json: { success: false, message: 'sorry, only owner can delete note', status: 422 },
             status: 422
    elsif @user_note.role == 'owner' && @user_note.user_id != @current_user
      @note = Note.find(params[:id])

      note_members = @note.users
      note_members.each do |member|
        if @note.note_type == 'collaboration'
          Notification.create(
            title: " Telah menghapus Catatan #{@note.subject}",
            body: params[:body],
            user_id: member.id,
            sender_id: current_user.id,
            sender_place: @note.id,
            place_name: @note.subject
          )
        elsif @note.note_type == 'team'
          Notification.create(
            title: "Telah menghapus Catatan #{@note.subject}",
            body: "#{current_user.username} Telah menghapus Catatan #{@note.subject}",
            user_id: member.id,
            sender_id: current_user.id,
            sender_place: @note.id,
            place_name: @note.subject
          )
        end
      end

      if @note.destroy
        render json: { success: true, message: 'note delete successfully', status: 200 },
               status: 200
      else
        render json: { success: false, message: 'note delete unsuccessfully', status: 422, data: @note.errors },
               status: 422
      end
    else
      render json: { success: false, message: 'note delete unsuccessfully', status: 422, data: @note.errors },
             status: 422
    end
  end

  def history
    note = Note.find_by(id: params[:id])
    if note.present?
      user_note = UserNote.find_by(user: current_user, note: note)
      render json: {status: 200, data: user_note.note_history(note)}, status: 200
    else
      render json: {status: 404, error: 'note not found'}, status: 404
    end
  end

  def remove_member
    member_emails = params[:email]
    members = User.where(email: member_emails)

    if members.empty?
      render json: { success: false, message: 'Members not found', status: 404 }, status: 404
    elsif members.include?(current_user)
      render json: { success: false, message: 'You cannot remove yourself', status: 422 }, status: 422
    else
      note = Note.find_by_id(params[:id])
      find_user_note = UserNote.find_by(user: current_user, note: note, role: 'owner')
      if find_user_note.present?
        user_note = note.user_note.where(user: members, noteinvitation_status: 1)
        if user_note.empty?
          render json: { success: false, message: 'Members are not part of the collab note', status: 422 }, status: 422
        else
          if user_note.destroy_all
            render json: { success: true, message: 'Members remove successfully', status: 200 }, status: 200
          else
            render json: { success: false, message: 'Failed to remove members', status: 500 }, status: 500
          end
        end
      else
        render json: { success: false, message: 'sorry, only owner can update note', status: 422, data: find_user_note },
              status: 422
      end
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
    params.permit(:subject, :description, :event_date, :reminder, :frequency, :ringtone_id, :column_id, :status)
  end

  def attach_params
    params.permit({path: []})
  end

  def transaction_params
    params.permit(:point, :point_type)
  end
  
end
