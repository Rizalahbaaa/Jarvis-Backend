class Column < ApplicationRecord
  has_many :note
  belongs_to :team

  validates :title, presence: true, length: { maximum: 100 }
  validates :team_id, presence: true

  def self.teamsval(current_user, team_id)
    @find_team = Team.find_by(id: team_id)
    @find_user_team = UserTeam.find_by(user: current_user, team: @find_team).present?
  end

  def new_attr(current_user)
    {
      id:,
      title:,
      team: team.title,
      note: note.map { |note| note.new_attr(current_user) }
    }
  end
end
