class Note < ApplicationRecord
  has_many :user_note
  has_many :users, through: :user_note, source: :user, dependent: :destroy
  has_many :notification

  belongs_to :column, optional: true
  belongs_to :ringtone

  validates :subject, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :event_date, presence: true
  validates :ringtone_id, presence: true
  validates :column_id, presence: false

  scope :join_usernote, -> { joins(:user_note) }
  scope :notefunc, -> (note_id) { join_usernote.where(user_note: { note_id: note_id })}
  scope :owners?, -> (user_id){ join_usernote.where(user_note: { role: 'owner', user_id: user_id }).limit(1).present?}

  enum note_type: {
    personal: 0,
    collaboration: 1,
    team: 2
  }

  enum status: {
    in_progress: 0,
    completed: 1
  }

  def new_attr
    {
      id:,
      subject:,
      description:,
      event_date:,
      ringtone: ringtone.name,
      column: self.column&.title,
      note_type:,
      status:,
      member: users.map { |user| user.username }
    }
  end
end
