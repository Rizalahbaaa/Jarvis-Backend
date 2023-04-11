class Note < ApplicationRecord
  has_many :user_notes
  has_many :profile, through: :user_notes, source: :profile
  has_many :notification
  has_many :invitation, as: :invitetable

  has_many :progresses

  has_many :reminders

  belongs_to :list, optional: true

  validates :subject, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :event_date, presence: true
  validates :ringtone_id, presence: false
  validates :note_type, presence: true
  validates :list_id, presence: false

  enum note_type: {
    personal: 0,
    collaboration: 1
  }

  def new_attr
    {
      id: self.id,
      subject:,
      description:,
      event_date:,
      reminder_date: reminders.map{ |reminder| reminder.reminder_date },
      note_type:,
      list: self.list&.title,
      member: profile.map { |profile| profile.user.email }
    }
  end
end
