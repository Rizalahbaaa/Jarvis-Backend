class Column < ApplicationRecord
  has_many :note
  belongs_to :team

  validates :title, presence: true, length: { maximum: 100 }
  validates :team_id, presence: true

  def new_attr
    {
      id:,
      title:,
      team: team.title,
      note: note.map { |note| note.new_attr }
    }
  end
end
