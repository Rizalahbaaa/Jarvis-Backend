class Column < ApplicationRecord
  has_many :note
  belongs_to :team

  validates :title, presence: true, length: { maximum: 100 }
  validates :team_id, presence: true

  def new_attr(current_user)
    {
      id:,
      title:,
      team: team.title,
      note: note.map { |note| note.new_attr(current_user) }
    }
  end
end
