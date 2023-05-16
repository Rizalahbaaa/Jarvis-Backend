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
  # scope :owners?, -> (user_id){ join_usernote.where(user_note: { role: 'owner', user_id: user_id })}
  scope :ownersfilter, ->(user_id) { join_usernote.where(user_note: { user_id: }) }

  enum note_type: {
    personal: 0,
    collaboration: 1,
    team: 2
  }

  enum status: {
    in_progress: 0,
    completed: 1
  }

  # def name
  #   subject
  # end

  def event_date_valid?
    return unless event_date.present?

    validates_comparison_of :event_date, greater_than: Time.now
  end

  def reminder_date_valid?
    return unless reminder.present?

    validates_comparison_of :reminder, greater_than: Time.now, less_than: event_date - 30.minutes
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
      event_date:,
      reminder:,
      ringtone: ringtone.name,
      file: file_collection,
      note_type:,
      status:,
      column: column&.title
    }
  end
end
