class Progress < ApplicationRecord

  belongs_to :profile
  belongs_to :note
  # has_one :transaction
  has_many :attach

  validates :status, presence: true
  validates :notes_id, presence: true
  validates :user_id, presence: true

  enum status: { on_progress: 0, completed: 1 }

  def new_attributes
    {
      id:,
      status:,
      notes_id:,
      profile:
    }
  end
end
