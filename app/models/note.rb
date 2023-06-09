class Note < ApplicationRecord
  has_many :user_note
  has_many :users, through: :user_note, source: :user, dependent: :destroy
  belongs_to :column, optional: true
  belongs_to :ringtone

  validates :subject, presence: { message: "can't be blank" }, length: { maximum: 30 }
  validates :description, presence: { message: "can't be blank" }, length: { maximum: 250 }
  validates :ringtone_id, presence: { message: 'ringtone must be assigned' }
  validates :event_date, presence: true
  validates :reminder, presence: true
  validates :column_id, presence: false
  validates :frequency, presence: false
  validate :reminder_date_valid?, :event_date_valid?

  scope :join_usernote, -> { joins(:user_note) }

# filters & sorts
  scope :noteall, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', user_id, 1, 0).where.not(note_type: 'team')}
  scope :passed_note, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', user_id, 1, 0).where('event_date < ? OR notes.status = ?', Time.now.in_time_zone('Jakarta'), 1).where.not(note_type: 'team') }
  scope :upcoming_note, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND (user_notes.noteinvitation_status = ? OR user_notes.role = ?)', user_id, 1, 0).where('event_date >= ?', Time.now.in_time_zone('Jakarta')).where.not(note_type: 'team') }
  scope :owner, -> (user_id){ join_usernote.where('user_notes.user_id = ? AND user_notes.role = ?', user_id, 0).where.not(note_type: 'team')}
  scope :upload_done, -> (user_id){ join_usernote.where('user_notes.role = ? AND user_notes.user_id = ? AND user_notes.status = ?', 1, user_id,1 ).where(note_type: 'collaboration')}
  scope :not_upload, -> (user_id){ join_usernote.where('user_notes.role = ? AND user_notes.user_id = ? AND user_notes.status = ? AND user_notes.noteinvitation_status = ?', 1, user_id, 0,1).where(note_type: 'collaboration')}
  scope :late, -> (user_id){ join_usernote.where('user_notes.role = ? AND user_notes.user_id = ? AND user_notes.status = ?', 1, user_id,3 ).where(note_type: 'collaboration')}
  scope :completed_note, ->(user_id){ join_usernote.where('user_notes.user_id = ?', user_id).where(status: 'completed').where.not(note_type: 'team')}

  enum note_type: {
    personal: 0,
    collaboration: 1,
    team: 2
  }

  enum frequency: {
    tidak_diulang: 0,
    harian: 1,
    mingguan: 2,
    bulanan: 3
  }

  enum status: {
    in_progress: 0,
    completed: 1
  }

  before_create :team_status


  def self.filter_and_sort(params, current_user)
    notes = Note.noteall(current_user)

    filter_options = {
      'owner' => :owner,
      'passed' => :passed_note,
      'upcoming' => :upcoming_note,
      'up' => :upload_done,
      'notup' => :not_upload,
      'late' => :late,
      'completed' => :completed_note
    }
  
    filter_options.each do |filter, method|
      if params[filter].present?
        notes = notes.merge(Note.send(method, current_user))
      end
    end
  
    sort_direction = params[:sort] == 'desc' ? 'desc' : 'asc'
    notes = notes.order(event_date: sort_direction)
  
    notes
  end

  def self.assign_member_to_note(emails, column, note)
    participant = []
    emails.each do |e|
      user = User.find_by(email: e)
      team = Team.find_by(column: Column.find_by_id(column))
      find_member = UserTeam.find_by(user: user, team: team, teaminvitation_status: 'Accepted')
      if find_member.present?
        check_member = UserNote.find_by(user_id: find_member.user_id, note: note)
        if check_member.nil?
          member = {
            note_id: note.id,
            user_id: find_member.user_id,
            role: 1,
            noteinvitation_status: 1
          }
        end
      end
      participant << member
    end
    UserNote.create(participant)
  end

  def self.send_reminder
    require 'rufus-scheduler'

    interval = Rufus::Scheduler.new
    now = Time.now.strftime('%F %R').in_time_zone('Jakarta')
    notes = Note.where('reminder = ?', now)

    if notes.present?
      notes.each do |n|
        users = UserNote.where('note_id = ? AND (role = ? OR noteinvitation_status = ?)', n.id, 0, 1)
        users.each do |u|
          ReminderMailer.my_reminder(u.user.email, n).deliver_now
          puts 'SENDING REMINDER NOW...'
          Note.send_notif(n, u.user.id)
          puts 'SEND NOTIF....'

          case n.frequency
          when 'harian'
            interval.every '1d' do
              ReminderMailer.my_repeater(u.user.email, n).deliver_now
              puts 'SENDING DAILY REMINDER...'
              Note.freq_notif(n, u.user.id)
              puts 'SEND DAILY NOTIF....'
            end
          when 'mingguan'
            interval.every '1w' do
              ReminderMailer.my_repeater(u.user.email, n).deliver_now
              puts 'SENDING WEEKLY REMINDER...'
              Note.freq_notif(n, u.user.id)
              puts 'SEND WEEKLY NOTIF....'
            end
          when 'bulanan'
            interval.every '1M' do
              ReminderMailer.my_repeater(u.user.email, n).deliver_now
              puts 'SENDING MONTHLY REMINDER...'
              Note.freq_notif(n, u.user.id)
              puts 'SEND MONTHLY NOTIF....'
            end
          end
        end
      end
    end
  end

  def self.send_notif(note, user)
    Notification.create(
      title: "Reminder!, #{note.subject}",
      body: "Tanggal event: #{note.event_date}",
      user_id: user,
      notif_type: 1,
      sender_place: note.id
    )
  end

  def self.freq_notif(note, user)
    Notification.create(
      title: "#{note.frequency} reminder untuk #{note.subject}",
      body: "tanggal event: #{Time.now.strftime('%F %R').in_time_zone('Jakarta')}",
      user_id: user
    )
  end

  # def name
  #   subject
  # end

  def self.teamates(current_user, note)
    @find_column = Column.find_by(id: note.column_id)
    @find_team = Team.find_by(id: @find_column.team_id)
    @find_user_team = UserTeam.find_by(user: current_user, team: @find_team).present?
  end

  def self.columncheck(current_user, column_id)
    @find_column = Column.find_by(id: column_id)
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

  
  def calculate_usernote 
    UserNote.where(note_id: self.id, role: 'member', noteinvitation_status: 'Accepted')
  end

  def calculate_upload
     UserNote.where(note_id: self.id, role: 'member', status:'have_upload') 
  end

  def calculate_progress
    total_tasks = calculate_usernote.count
    note_done = calculate_upload.count 
    return 0 if total_tasks.zero?
    (note_done.to_f / total_tasks) * 100
  end

  def precentage
    if self.status == 'completed'
      'completed'
    else
      "#{calculate_progress.to_i}%"
    end
  end

  def new_attr(current_user)
    {
      id:,
      subject:,
      description:,
      owner: owner_collab.map { |owner| owner.new_attr },
      member: accepted_member.map { |accept_user| accept_user.new_attr },
      event_date:,
      reminder: ,
      frequency: ,
      ringtone_id: ringtone.id,
      ringtone: ringtone.name,
      file: file_collection,
      note_type: self.note_type,
      status: owner_collab.map { |owner| owner == current_user ? precentage : user_note&.find_by(user_id: current_user.id, note_id: self.id)&.status},
      column: column&.title,
    }
  end

  def member_side(current_user)

    member = UserNote.find_by(note: self.id, user: current_user)
    attach_current = Attach.where(user_note: member).map(&:path).map(&:url)
    {
      id:,
      subject:,
      description:,
      owner: owner_collab.map { |owner| owner.new_attr },
      member: accepted_member.map { |accept_user| accept_user.new_attr },
      event_date:,
      reminder:,
      frequency: ,
      ringtone_id: ringtone.id,
      ringtone: ringtone.name,
      file: attach_current,
      note_type:,
      status: member.status,
      column: column&.title
    }
  end
end
