class Reminder < ApplicationRecord
  belongs_to :note

  validates :note_id, presence: true
  validates :reminder_date, presence: true

  def new_attr
    {
      id:,
      note: self.new_note,
      reminder_date:
    }
  end

  def new_note
    {
      subject: note.subject,
      description: note.description
    }
  end
end
