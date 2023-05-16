class Team < ApplicationRecord
  has_many :user_team
  has_many :user, through: :user_team, source: :user, dependent: :destroy
  has_many :column

  validates :title, presence: {message: "can't be blank"}, length: { maximum: 100 }

  scope :join_userteam, -> { joins(:user_team) }
  scope :teamfunc, -> (team_id) { join_userteam.where(user_team: { team_id: team_id })}
  scope :owners?, -> (user_id){ join_userteam.where(user_team: { team_role: 'owner', user_id: user_id }).limit(1).present?}

  def accepted_member
    accepted_user_teams = user_team.where(teaminvitation_status: 1, team_role: 1)
    accepted_user_teams.map(&:user)
  end

  def team_owner
    team_owner = user_team.where(team_role: 0)
    team_owner.map(&:user)
  end

  def new_attr
    {
      id:,
      title:,
      owner: team_owner.map{ |owner| owner.new_attr},
      participant: accepted_member.map{ |accept_user| accept_user.new_attr}
    }
  end
end
