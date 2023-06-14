class UserNote < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user
  belongs_to :note
  has_many :attaches, dependent: :destroy
  has_many :transactions

  validates :note_id, presence: true
  validates :user_id, presence: true

  enum :noteinvitation_status, { Pending: 0, Accepted: 1, Rejected: 2 }

  enum role: {
    owner: 0,
    member: 1
  }

  enum status: {
    not_upload_yet: 0,
    have_upload: 1,
    completed: 2,
    late: 3
  }
  def completed?
    note.nil? ? (status == 'completed') : (status == 'completed' && note.completed?)
  end
  
  def invitation_valid?
    noteinvitation_status == 'Pending' && noteinvitation_expired > Time.now
  end

  def accept_invitation!
    self.noteinvitation_status = 1
    save!
  end

  def decline_invitation!
    self.noteinvitation_status = 2
    destroy
  end

  def update_status
    ontime_file = Attach.where('self.created_at < ?', note.event_date)
    late_file = Attach.where('self.created_at > ?', note.event_date)

    self.status = if ontime_file
                    'have_upload'
                  elsif late_file
                    'late'
                  else
                    'not_upload_yet'
                  end
    save!
  end

  def self.auto_change_status
    late_upload = Note.where('event_date < ?', Time.now.strftime('%F %R').in_time_zone('Jakarta'))
    # progress_note = late_upload
    # progress_note.update_all(status: 'completed')
    if late_upload.present?
      late_upload.each do |l|
        user_late = UserNote.where(note: l, noteinvitation_status: 'Accepted', role: 'member', status: 'not_upload_yet')
        user_late.update_all(status: 'late')
      end
    end
  end

  def update_time
    updated_at = Time.now
    save
  end

  def note_history(note)
    sort = UserNote.order('updated_at ASC')
    histories = sort.user_note_data(note)

    owner = UserNote.find_by(role: 'owner', note_id: note.id)
    {
      owner: owner.user.new_attr,
      histories: histories.map{|h| h.new_attr},
      note_created_at: note.created_at,
      note_done_at: note.updated_at,
      note_status: note.status
    }
  end

  def self.user_note_data(note)
    member = []
    UserNote.where(role: 'member', note: note, status: 'have_upload').each do |m|
      member.push(User.find_by(id: m.user_id))
    end
  end

  def self.delete_expired_invitations
    expired_invitations = UserNote.where('teaminvitation_status = ? && teaminvitation_expired < ?',
                                         UserTeam.teaminvitation_statuses[:Pending], Time.now)
    expired_invitations.destroy
  end

  def docs
    attaches.map(&:path)
  end

  def owner_note
    User.find_by_id(user_note.find_by(role: "owner"))
  end

  def new_attr
    {
      id:,
      note: note.subject,
      user: user.username,
      file: docs.map(&:url),
      role:,
      status:,
      date: updated_at
    }
  end


  def owner_note
    UserNote.find_by(note_id: self.note_id, role: "owner")
  end

  def message_inv
    'mengirim anda sebuah catatan'
  end

  def sending
    time_send = Time.now - owner_note&.updated_at
    time_ago = distance_of_time_in_words(owner_note&.updated_at, Time.now, locale: :id)
    
    {
      time_send: time_send,
      time_ago: time_ago
    }
  end

  BACKEND_DOMAIN = if Rails.env.development?
    'http://localhost:3000/api'
  else
    'https://bantuin.fly.dev/api'
  end

  def inv_request
    {
      id:,
      from: owner_note&.user&.username,
      photo: owner_note&.user&.photo&.url,
      message: message_inv,
      note: note.subject, 
      actions: [
        { action: "accept", url: "#{BACKEND_DOMAIN}/note/inv/accept_invitation/#{self.noteinvitation_token}" },
        { action: "reject", url: "#{BACKEND_DOMAIN}/note/inv/decline_invitation/#{self.noteinvitation_token}" }
      ],
      date_invite: "#{sending[:time_ago]} yang lalu" 
    }
  end

end
