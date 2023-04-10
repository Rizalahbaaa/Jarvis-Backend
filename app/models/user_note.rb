class UserNote < ApplicationRecord
  belongs_to :profile
  belongs_to :note

  validates :note_id, presence: true
  validates :user_id, presence: true
  validates :role, presence: true

  enum role: {
    member: 0,
    owner: 1
  }

  def new_attr
    {
      id:,
      note: note.new_attr,
      user: user.new_attr,
      role:
    }
  end
end
