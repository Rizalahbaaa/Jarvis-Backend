class Progress < ApplicationRecord

  belongs_to :profile
  belongs_to :note
  has_one :transactions
  has_many :attaches

  validates :status, presence: true
  validates :note_id, presence: true
  validates :profile_id, presence: true

  enum status: { on_progress: 0, completed: 1 }

  def new_attr
    {
      id:,
      status:,
      note: note.subject,
      profile: profile.username,
      file: attaches.map{ |attach| attach.path }
    }
  end
end
