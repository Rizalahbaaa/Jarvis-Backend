class Note < ApplicationRecord
  has_many :user_notes
  has_many :users, through: :user_notes, source: :user
  has_many :notification
  has_many :invitation, as: :invitetable

  belongs_to :column, optional: true
  belongs_to :ringtone

  validates :subject, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :event_date, presence: true
  validates :ringtone_id, presence: true
  validates :column_id, presence: false

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
      status:
      # member: profile.map { |profile| profile.user.email }
    }
  end
end
