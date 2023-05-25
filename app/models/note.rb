class Note < ApplicationRecord
  has_many :user_note
  has_many :users, through: :user_note, source: :user, dependent: :destroy
  # has_many :notification
  belongs_to :column, optional: true
  belongs_to :ringtone

  validates :subject, presence: { message: "can't be blank" }, length: { maximum: 30 }
  validates :description, presence: { message: "can't be blank" }, length: { maximum: 100 }
  validates :ringtone_id, presence: { message: 'ringtone must be assigned' }
  validates :event_date, presence: true
  validates :reminder, presence: true
  validates :column_id, presence: false
  validate :reminder_date_valid?, :event_date_valid?

  scope :join_usernote, -> { joins(:user_note) }
  # scope :notefunc, -> (note_id) { join_usernote.where(user_note: { note_id: note_id })}

# filters & sorts
  # scope :noteall, -> (user_id){ join_usernote.where(user_note: { user_id: user_id}).where.not(note_type: 'team')}
  scope :noteall, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', user_id, 1, 0).where.not(note_type: 'team')}
  scope :passed_note, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', user_id, 1, 0).where('event_date < ?', Date.today).where.not(note_type: 'team') }
  scope :upcoming_note, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', user_id, 1, 0).where('event_date >= ?', Date.today).where.not(note_type: 'team') }
  scope :owner, -> (user_id){ join_usernote.where(user_note: { role: 'owner', user_id: user_id }).where.not(note_type: 'team')}
  scope :upload_done, -> (user_id){ join_usernote.where(user_note: { role: 'member', user_id: user_id, status:'have_upload' }).where(note_type: 'collaboration')}
  scope :not_upload, -> (user_id){ join_usernote.where(user_note: { role: 'member', user_id: user_id, status:'not_upload_yet' }).where(note_type: 'collaboration')}
  scope :late, -> (user_id){ join_usernote.where(user_note: { role: 'member', user_id: user_id, status:'late' }).where(note_type: 'collaboration')}
  scope :completed_note, ->{ where(status: 'completed').where.not(note_type: 'team') }

  enum note_type: {
    personal: 0,
    collaboration: 1,
    team: 2
  }

  enum status: {
    in_progress: 0,
    completed: 1
  }
  before_create :team_status


  def self.filter_and_sort(params, current_user)

    notes = Note.noteall(current_user)

    if params[:note] == 'passed'
      notes = Note.passed_note(current_user)
    end
    if params[:note] == 'upcoming'
      notes = Note.upcoming_note(current_user)
    end 
    if params[:owner] == 'yes'
      notes = Note.owner(current_user)
    end
    if params[:up] == 'no'
      notes = Note.not_upload(current_user)
    end
    if params[:up] == 'yes'
      notes = Note.upload_done(current_user)
    end
    if params[:late] == 'yes'
      notes = Note.late(current_user)
    end
    if params[:completed] == 'yes'
      notes = Note.completed_note
    end

    sort_direction = params[:sort] == 'desc' ? 'desc' : 'asc'
    notes = notes.order(event_date: sort_direction)

    return notes
  end

  def self.ref_note(current_user)
    # remind = Note.where('reminder = ?', Time.now)
    my_note = Note.joins(:user_note).where('user_id = ? AND note_id = ?', current_user.id, self.id)
  end

  def self.send_reminder
    notes = Note.where('reminder = ?', Time.now.strftime('%F %I:%M'))
    users = UserNote.where(note: notes)
    users.each do |u|
      if notes.present?
        notes.each do |n|
          ReminderMailer.my_reminder(u.user.email, n).deliver_now
          puts 'SENDING REMINDER...'
        end
      else
        puts 'NO EMAIL SEND :('
      end
    end
  end

  # def name
  #   subject
  # end

  def self.teamates(current_user, note)
    @find_column = Column.find_by(id: note.column_id)
    @find_team = Team.find_by(id: @find_column.team_id)
    @find_user_team = UserTeam.find_by(user: current_user, team: @find_team).present?
  end

  def team_status
    if self.column_id.present?
      self.note_type = 'team'
    end
  end

  def event_date_valid?
    return unless event_date.present?

    validates_comparison_of :event_date, greater_than: Time.now
  end

  def reminder_date_valid?
    return unless reminder.present?

    validates_comparison_of :reminder, greater_than: Time.now, less_than: event_date
  end

  def owner_collab
    owner = user_note.where(role: 0)
    owner.map(&:user)
  end

  def accepted_member
    accepted_user_notes = user_note.where(noteinvitation_status: 1, role: 1)
    accepted_user_notes.map(&:user)
  end

  def file_collection
    user_note.map { |f| f.attaches.map { |attach| attach.path.url } }.flatten
  end

  def new_attr
    {
      id:,
      subject:,
      description:,
      owner: owner_collab.map { |owner| owner.new_attr },
      member: accepted_member.map { |accept_user| accept_user.new_attr },
      event_date: event_date.strftime('%F %I:%M'),
      reminder: reminder.strftime('%F %I:%M'),
      ringtone_id: ringtone.id,
      ringtone: ringtone.name,
      file: file_collection,
      note_type:,
      status:,
      column: column&.title
    }
  end

  def member_side(current_user_note)
    attach_current = Attach.where(user_note: current_user_note).map(&:path).map(&:url)
    {
      id:,
      subject:,
      description:,
      owner: owner_collab.map { |owner| owner.new_attr },
      member: accepted_member.map { |accept_user| accept_user.new_attr },
      event_date: event_date.strftime('%F %I:%M'),
      reminder: reminder.strftime('%F %I:%M'),
      ringtone_id: ringtone.id,
      ringtone: ringtone.name,
      file: attach_current,
      note_type:,
      status:,
      column: column&.title
    }
  end
end
