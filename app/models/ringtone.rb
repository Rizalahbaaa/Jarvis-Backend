class Ringtone < ApplicationRecord
  has_many :team_note
  has_many :note

  validates :name, presence: true
  validates :file, presence: true

  def new_attr
    {
      id:,
      name:,
      file:
    }
  end
end
