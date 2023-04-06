class Note < ApplicationRecord
  has_many :user_notes
  has_many :users, through: :user_notes, source: :user, dependent: :destroy

  validates :subject, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
  validates :event_date, presence: true
  validates :reminder_date, presence: true
  validates :ringtone_id, presence: false

  def new_attr
    {
      id:,
      subject:,
      description:,
      event_date:,
      reminder:
    }
  end

  def reminder
    dsubs = (event_date - reminder_date)
  end
end
