class UserNote < ApplicationRecord
  belongs_to :user
  belongs_to :note
  has_many :attaches
  has_many :transactions

  validates :note_id, presence: true
  validates :user_id, presence: true
  validates :reminder, presence: true

  enum role: {
    owner: 0,
    member: 1
  }

  enum status: {
    on_progress: 0,
    completed: 1,
    late: 2
  }

  def new_attr
    {
      id:,
      note: note.new_attr,
      user: user.username,
      reminder:,
      role:,
      status:
    }
  end
end
