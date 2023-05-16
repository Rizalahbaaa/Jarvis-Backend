class UserNote < ApplicationRecord
  belongs_to :user
  belongs_to :note
  has_many :attaches
  has_many :transactions

  validates :note_id, presence: true
  validates :user_id, presence: true

  enum :noteinvitation_status, { Pending: 0, Accepted: 1, Rejected: 2 }

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
    ontime_file = attaches.where('self.created_at < ?', note.event_date)
    late_file = attaches.where('self.created_at > ?', note.event_date)

    self.status = if ontime_file
                    'completed'
                  elsif late_file
                    'late'
                  else
                    'on_progress'
                  end
    save!
  end

  def update_time
    updated_at = Time.now
    save
  end

  def self.sort_history
    asc_sort = UserNote.order('updated_at ASC')
    asc_sort.user_note_data
  end

  def self.user_note_data
    owner = User.find_by_id(UserNote.find_by(role: "owner").try("user_id"))
    member = []
    UserNote.where(role: "member").each do |m|
      member.push(User.find_by(id: m.user_id))
    end
  end

  def delete_expired_invitations
    expired_invitations = UserNote.where('teaminvitation_status = ? && teaminvitation_expired < ?',
                                         UserTeam.teaminvitation_statuses[:Pending], Time.now)
    expired_invitations.destroy
  end

  def docs
    attaches.map(&:path)
  end

  enum role: {
    owner: 0,
    member: 1
  }

  enum status: {
    not_upload_yet: 0,
    have_upload: 1,
    complete: 2,
    late: 3
  }

  def new_attr
    {
      id:,
      note: note,
      user: user.username,
      file: docs.map(&:url),
      role:,
      status:
      # invitation_token: self.noteinvitation_token,
      # invitation_status: self.noteinvitation_status,
      # invitation_expired: self.noteinvitation_expired
    }
  end
end
